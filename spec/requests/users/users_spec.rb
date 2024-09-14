require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |config|
  config.include UserHelpers
end

RSpec.describe "Users Controller tests" do
  it "retrieves the user" do
    user = create(:user)
    login(user)
    get user_path(user)
    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:show)
  end
  context "user is admin" do
    it "allows the user to be deleted" do
      regular_user = create(:user)
      admin_user = create(:admin_user)
      login(admin_user)
      expect do
        delete user_path(regular_user)
      end.to change { User.count }
      expect(response).to redirect_to(users_path)
      get user_path(id: regular_user.id)
      expect(response).to have_http_status(:not_found)
    end
  end
  context "user is not admin" do
    it "does not allow the user to be delete" do
      regular_user = create(:user)
      admin_user = create(:admin_user)
      login(regular_user)
      expect do
        delete user_path(admin_user)
      end.to_not change { User.count }
      expect(response).to redirect_to(root_path)
      get user_path(admin_user)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
    end
  end
  context "with valid params" do
    it "creates a new user" do
      post users_path, params: {
        user: {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          password: Faker::Internet.password
        }
      }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(user_path(User.last))
    end
    it "updates the user" do
      user = create(:user)
      login(user)
      patch user_path(user), params: {
        user: {
          name: "user_name_updated"
        }
      }
      expect(response).to have_http_status(:found)
      user.reload
      expect(user.name).to eq("user_name_updated")
    end
  end
  context "with invalid params" do
    it "does not create a new user" do
      post users_path, params: {
        user: {
          name: Faker::Name.name,
          email: Faker::Internet.email
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
    end
    it "does not update the user" do
      user = create(:user)
      old_name = user.name
      login(user)
      patch user_path(user), params: {
        user: {
          name: "new_name",
          email: "invalid_email"
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:edit)
      user.reload
      expect(user.name).to eq(old_name)
    end
  end
end
