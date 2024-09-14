require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |config|
  config.include UserHelpers
end

RSpec.describe "Accounts CRUD Operations" do
  let!(:user) { create(:user) }
  let!(:account) { create(:account, user: user) }

  before do
    login(user)
  end

  describe 'GET account' do
    it 'renders the account page if the account exists' do
      get account_path(account)
      expect(response).to render_template("show")
    end
    it 'raises an exception if the account doesnt exist' do
      get account_path(id: 999)
      expect(response).to have_http_status(:not_found)
      expect(response.body).to match(/Couldn't find Account with/)
    end
  end

  describe 'POST accounts' do
    context 'with valid params' do
      it 'should create an account' do
        post accounts_path, params: {
          account: {
            name: "test_account_2",
            account_type: :RRSP,
            cash: 0.0,
            description: "test_account",
            financial_institution: "questrade"
          }
        }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(account_path(Account.last))
      end
    end
    context 'with invalid params' do
      it 'should not create an account' do
        expect do
          post accounts_path, params: {
            account: {
              name: "test_account_2",
              cash: 0.0,
              description: "test_account",
              financial_institution: "questrade"
            }
          }
        end.to_not change { Account.count }
        expect(response).to render_template(:new)
        expect(response.body).to include('errors')
      end
    end
  end

  describe 'PATCH accounts' do
    context 'with valid params' do
      it 'should update the account' do
        patch account_path(account), params: {
          account: {
            name: "test_account_updated"
          }
        }
        expect(response).to have_http_status(:found)
        account.reload
        expect(account.name).to eq("test_account_updated")
      end
    end
    context 'with invalid params' do
      it 'should not update the account' do
        patch account_path(account), params: {
          account: {
            account_type: :INVALID,
            name: "test_account_updated"
          }
        }
        expect(response).to have_http_status(:unprocessable_content)
        account.reload
        expect(account.name).to eq("test_account")
        expect(response).to render_template(:edit)
        expect(response.body).to include('errors')
      end
    end
  end

  describe 'Add Cash' do
    context 'with valid params' do
      it 'adds cash to the account' do
        previous_balance = account.cash
        patch account_edit_cash_path(account), params: {
          account: {
            cash: "1000.0",
            edit_cash_type: "add"
          }
        }
        expect(response).to have_http_status(:found)
        account.reload
        expect(account.cash).to eq(previous_balance + 1000)
      end
    end
    context 'with invalid params' do
      it 'does not add cash to the account' do
        previous_balance = account.cash
        patch account_edit_cash_path(account), params: {
          account: {
            cash: "one thousand dollars",
            edit_cash_type: "add"
          }
        }
        expect(response).to have_http_status(:found)
        account.reload
        expect(account.cash).to eq(previous_balance)
      end
    end
  end

  describe 'Remove Cash' do
    context 'with valid params' do
      it 'removes cash from the account' do
        previous_balance = account.cash
        patch account_edit_cash_path(account), params: {
          account: {
            cash: "1000.0",
            edit_cash_type: "remove"
          }
        }
        expect(response).to have_http_status(:found)
        account.reload
        expect(account.cash).to eq(previous_balance - 1000)
      end
    end
    context 'with invalid params' do
      it 'does not remove cash from the account' do
        previous_balance = account.cash
        patch account_edit_cash_path(account), params: {
          account: {
            cash: "one thousand dollars",
            edit_cash_type: "remove"
          }
        }
        expect(response).to have_http_status(:found)
        account.reload
        expect(account.cash).to eq(previous_balance)
      end
    end
  end

  describe 'Transfer Cash' do
    context 'with valid params' do
      context 'from an unregistered to a registered account' do
        it 'transfers cash from one account to another and updates the registered account contributions' do
          to_account = create(:rrsp_account, user: user)
          registered_account_limits = create(:registered_account_limit, user: user)
          to_account_previous_balance = to_account.cash
          previous_rrsp_contributions = registered_account_limits['rrsp_contributions']
          from_account_previous_balance = account.cash
          patch account_edit_cash_path(account), params: {
            account: {
              cash: "1000.0",
              to_account_id: to_account.id,
              edit_cash_type: "transfer"
            }
          }
          expect(response).to have_http_status(:found)
          account.reload
          to_account.reload
          registered_account_limits.reload
          expect(account.cash).to eq(from_account_previous_balance - 1000)
          expect(to_account.cash).to eq(to_account_previous_balance + 1000)
          expect(registered_account_limits['rrsp_contributions']).to eq(previous_rrsp_contributions + 1000)
        end
      end
      context 'from an unregistered to an unregistered account' do
        it 'transfers cash from one account to another' do
          to_account = create(:account, user: user)
          to_account_previous_balance = to_account.cash
          from_account_previous_balance = account.cash
          patch account_edit_cash_path(account), params: {
            account: {
              cash: "1000.0",
              to_account_id: to_account.id,
              edit_cash_type: "transfer"
            }
          }
          expect(response).to have_http_status(:found)
          account.reload
          to_account.reload
          expect(account.cash).to eq(from_account_previous_balance - 1000)
          expect(to_account.cash).to eq(to_account_previous_balance + 1000)
        end
      end
      context 'from a registered account to a registered account of a different type' do
        it 'transfers cash from one account to another and updates the registered account contributions' do
          from_account = create(:tfsa_account, user: user)
          to_account = create(:rrsp_account, user: user)
          registered_account_limits = create(:registered_account_limit, user: user)
          to_account_previous_balance = to_account.cash
          previous_rrsp_contributions = registered_account_limits['rrsp_contributions']
          from_account_previous_balance = from_account.cash
          patch account_edit_cash_path(from_account), params: {
            account: {
              cash: "1000.0",
              to_account_id: to_account.id,
              edit_cash_type: "transfer"
            }
          }
          expect(response).to have_http_status(:found)
          from_account.reload
          to_account.reload
          registered_account_limits.reload
          expect(from_account.cash).to eq(from_account_previous_balance - 1000)
          expect(to_account.cash).to eq(to_account_previous_balance + 1000)
          expect(registered_account_limits['rrsp_contributions']).to eq(previous_rrsp_contributions + 1000)
        end
      end
      context 'from a registered account to a registered account of the same type' do
        it 'transfers cash from one account to another and does not change contributions' do
          from_account = create(:rrsp_account, user: user)
          to_account = create(:rrsp_account, user: user)
          registered_account_limits = create(:registered_account_limit, user: user)
          to_account_previous_balance = to_account.cash
          previous_rrsp_contributions = registered_account_limits['rrsp_contributions']
          from_account_previous_balance = from_account.cash
          patch account_edit_cash_path(from_account), params: {
            account: {
              cash: "1000.0",
              to_account_id: to_account.id,
              edit_cash_type: "transfer"
            }
          }
          expect(response).to have_http_status(:found)
          from_account.reload
          to_account.reload
          registered_account_limits.reload
          expect(from_account.cash).to eq(from_account_previous_balance - 1000)
          expect(to_account.cash).to eq(to_account_previous_balance + 1000)
          expect(registered_account_limits['rrsp_contributions']).to eq(previous_rrsp_contributions)
        end
      end
      context 'from a registered account to an unregistered account' do
        it 'transfers cash from one account to another and does not change contributions' do
          from_account = create(:account, user: user)
          to_account = create(:account, user: user)
          registered_account_limits = create(:registered_account_limit, user: user)
          rrsp_contributions = registered_account_limits['rrsp_contributions']
          tfsa_contributions = registered_account_limits['tfsa_contributions']
          fhsa_contributions = registered_account_limits['fhsa_contributions']
          to_account_previous_balance = to_account.cash
          from_account_previous_balance = from_account.cash
          patch account_edit_cash_path(from_account), params: {
            account: {
              cash: "1000.0",
              to_account_id: to_account.id,
              edit_cash_type: "transfer"
            }
          }
          expect(response).to have_http_status(:found)
          from_account.reload
          to_account.reload
          registered_account_limits.reload
          expect(from_account.cash).to eq(from_account_previous_balance - 1000)
          expect(to_account.cash).to eq(to_account_previous_balance + 1000)
          expect(registered_account_limits['rrsp_contributions']).to eq(rrsp_contributions)
          expect(registered_account_limits['tfsa_contributions']).to eq(tfsa_contributions)
          expect(registered_account_limits['fhsa_contributions']).to eq(fhsa_contributions)
        end
      end
    end
    context 'with invalid params' do
      it 'does not allow transfers with invalid params' do
        from_account = create(:account, user: user)
        previous_account_balance = from_account.cash
        patch account_edit_cash_path(from_account), params: {
          account: {
            cash: "1000.0",
            to_account_id: "invalid-id",
            edit_cash_type: "transfer"
          }
        }
        expect(response).to have_http_status(:bad_request)
        account.reload
        expect(account.cash).to eq(previous_account_balance)
      end
      it 'does not allow transfers to an account the user does not own' do
        other_user = create(:user)
        other_user_account = create(:account, user: other_user)
        from_account = create(:account, user: user)
        previous_account_balance = from_account.cash
        patch account_edit_cash_path(from_account), params: {
          account: {
            cash: "1000.0",
            to_account_id: other_user_account.id,
            edit_cash_type: "transfer"
          }
        }
        expect(response).to have_http_status(:bad_request)
        account.reload
        expect(account.cash).to eq(previous_account_balance)
      end
      it 'does not allow transfers to the same account' do
        from_account = create(:account, user: user)
        previous_account_balance = from_account.cash
        patch account_edit_cash_path(from_account), params: {
          account: {
            cash: "1000.0",
            to_account_id: from_account.id,
            edit_cash_type: "transfer"
          }
        }
        expect(response).to have_http_status(:bad_request)
        account.reload
        expect(account.cash).to eq(previous_account_balance)
      end
    end
  end

  describe 'DELETE accounts' do
    it 'deletes the account' do
      account_id = account.id
      expect do
        delete account_path(account)
      end.to change { Account.count }
      expect(response).to redirect_to(accounts_path)
      get account_path(id: account_id)
      expect(response).to have_http_status(:not_found)
    end
  end
end
