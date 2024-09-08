require "rails_helper"
require "./spec/support/user_helpers"

RSpec.configure do |config|
  config.include UserHelpers
end

RSpec.describe "Users Controller tests" do
  it "shows the current user" do
  end
  it "deletes the user" do
  end
  context "with valid params" do
    it "creates a new user" do
    end
    it "updates a user" do
    end
  end
  context "with invalid params" do
    it "does not create a new user" do
    end
    it "does not update a user" do
    end
  end
end
