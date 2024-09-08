require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |config|
  config.include UserHelpers
end

RSpec.describe "Registered account limits Controller tests" do
  let!(:user) { create(:user) }
  let!(:registered_account_limit) { create(:registered_account_limit, user: user) }

  before do
    login(user)
  end

  it "does not allow the registered account limit to be deleted" do
    expect do
      delete registered_account_limit_path(registered_account_limit)
    end.to_not change { RegisteredAccountLimit.count }
    expect(response).to have_http_status(:not_found)
    user.reload
    expect(user.registered_account_limit).to_not be_nil
  end

  it "does not allow a new registered account limit to be created" do
    expect do
      post registered_account_limits_path, params: {
        registered_account_limit: {}
      }
    end.to_not change { RegisteredAccountLimit.count }
    expect(response).to have_http_status(:not_found)
  end

  it "creates a new registered account limit automatically" do
    new_user = create(:user)
    login(new_user)
    get registered_account_limits_path
    expect(response).to render_template(:index)
    new_user.reload
    expect(new_user.registered_account_limit).to_not be_nil
    registered_account_limit = new_user.registered_account_limit
    expect(registered_account_limit.tfsa_limit).to eq(0.0)
    expect(registered_account_limit.rrsp_limit).to eq(0.0)
    expect(registered_account_limit.fhsa_limit).to eq(0.0)
    expect(registered_account_limit.tfsa_contributions).to eq(0.0)
    expect(registered_account_limit.rrsp_contributions).to eq(0.0)
    expect(registered_account_limit.fhsa_contributions).to eq(0.0)
  end

  context "with valid params" do
    it "updates the registered account limit" do
      patch registered_account_limit_path(registered_account_limit), params: {
        registered_account_limit: {
          tfsa_limit: 2000
        }
      }
      expect(response).to have_http_status(:see_other)
      registered_account_limit.reload
      expect(registered_account_limit.tfsa_limit).to eq(2000)
    end
  end
  context "with invalid params" do
    it "Does not updated the registered account limit" do
      old_tfsa_limit = registered_account_limit.tfsa_limit
      patch registered_account_limit_path(registered_account_limit), params: {
        registered_account_limit: {
          tfsa_limit: "some_string"
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      registered_account_limit.reload
      expect(registered_account_limit.tfsa_limit).to eq(old_tfsa_limit)
    end
  end
end
