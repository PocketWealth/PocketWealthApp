require "test_helper"

class StocksEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @stock = @user.accounts.first.stocks.first
  end
  test "unsuccessful edit invalid quantity" do
    log_in_as(@user)
    get edit_stock_path(@stock)
    assert_template 'stocks/edit'
    patch stock_path(@stock), params: { stock: { quantity_purchased: 0 } }
    assert_response :unprocessable_entity
    assert_template "stocks/edit"
  end

  test "successful edit should not change account id" do
    log_in_as(@user)
    other_user_account = accounts(:archer_account)
    get edit_stock_path(@stock)
    assert_template 'stocks/edit'
    patch stock_path(@stock), params: { stock: { account_id: other_user_account.id } }
    assert_redirected_to @stock
    @stock.reload
    assert_equal(accounts(:michael_account), @stock.account)
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_stock_path(@stock)
    assert_template 'stocks/edit'
    patch stock_path(@stock), params: { stock: { symbol: "STOCK" } }
    assert_redirected_to @stock
  end
end
