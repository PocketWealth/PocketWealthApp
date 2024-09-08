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
