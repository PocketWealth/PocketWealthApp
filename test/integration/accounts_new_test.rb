require "test_helper"

class AccountsNewTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "successful create" do
    log_in_as(@user)
    get new_account_path
    assert_template "accounts/new"
    post accounts_path, params: { account: { name: "hello", account_type: "RRSP" } }
    follow_redirect!
    assert_template 'accounts/show'
  end

  test "unsuccessful create" do
    log_in_as(@user)
    get new_account_path
    assert_template "accounts/new"
    post accounts_path, params: { account: { name: "hello", account_type: "TFSB" } }
    assert_response :unprocessable_entity
    assert_template "accounts/new"
  end
end
