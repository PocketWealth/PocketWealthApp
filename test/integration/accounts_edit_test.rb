require "test_helper"

class AccountsEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @account = accounts(:michael_account)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_account_path(@account)
    assert_template 'accounts/edit'
    patch account_path(@account), params: { account: { name: "hello", account_type: "" } }
    assert_template 'accounts/edit'
  end

  test "unsuccessful edit invalid account type" do
    log_in_as(@user)
    get edit_account_path(@account)
    assert_template 'accounts/edit'
    patch account_path(@account), params: { account: { name: "hello", account_type: "TFSB" } }
    assert_template 'accounts/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_account_path(@account)
    assert_template 'accounts/edit'
    patch account_path(@account), params: { account: { name: "hello", account_type: "RRSP" } }
    assert_redirected_to @account
  end
end
