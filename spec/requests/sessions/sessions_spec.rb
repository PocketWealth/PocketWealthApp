require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |config|
  config.include UserHelpers
end

RSpec.describe "Sessions Controller tests" do
  let!(:user) { create(:user) }
  context "user is not logged in" do
    it "allows the user to login with valid credentials" do
      get login_path
      expect(is_logged_in?).to be_falsey
      login(user)
      expect(is_logged_in?).to be_truthy
    end
    it "does not login the user invalid credentials" do
      get login_path
      expect(is_logged_in?).to be_falsey
      post login_path, params: { session: { email: user.email, password: 'invalid' } }
      expect(is_logged_in?).to be_falsey
    end
    it "redirects the user to the login page" do
      get home_path
      expect(response).to redirect_to(login_path)
    end
  end
  context "user is logged in" do
    it "allows the user to access the home page" do
      get login_path
      expect(is_logged_in?).to be_falsey
      login(user)
      expect(is_logged_in?).to be_truthy
      get home_path
      expect(response).to render_template("accounts/index")
    end
    it "logs out the user" do
      get login_path
      expect(is_logged_in?).to be_falsey
      login(user)
      expect(is_logged_in?).to be_truthy
      logout
      expect(is_logged_in?).to be_falsey
      get home_path
      expect(response).to redirect_to(login_path)
    end
  end
end
