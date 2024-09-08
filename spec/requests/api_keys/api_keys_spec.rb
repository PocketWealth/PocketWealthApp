require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |config|
  config.include UserHelpers
end

RSpec.describe "API Keys Controller tests" do
  let!(:user) { create(:user) }
  let!(:api_key) { create(:api_key, user: user) }

  before do
    login(user)
  end

  it "deletes the API key" do
    expect do
      delete api_key_path(api_key)
    end.to change { ApiKey.count }
    expect(response).to redirect_to(api_keys_path)
    get api_key_path(api_key)
    expect(response).to have_http_status(:not_found)
  end
  context "with valid params" do
    it "creates a new API key" do
      post api_keys_path, params: {
        api_key: {
          provider: "some_provider",
          access_token: "some_access_token",
          refresh_token: "some_refresh_token",
          url: "some_url"
        }
      }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(api_key_path(ApiKey.last))
    end
    it "updates the API key" do
      patch api_key_path(api_key), params: {
        api_key: {
          provider: "some_provider_updated"
        }
      }
      expect(response).to have_http_status(:found)
      api_key.reload
      expect(api_key.provider).to eq("some_provider_updated")
    end
  end
end
