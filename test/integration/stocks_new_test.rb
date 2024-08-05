require "test_helper"

class StocksNewTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "successful create" do
    assert_difference("Stock.count") do
      log_in_as(@user)
      get new_stock_path
      assert_template "stocks/new"
      account_id = @user.accounts.first.id
      post stocks_path, params: { stock: {
        symbol: "AMZN", share_price: 150.0, quantity_purchased: 10, account_id: account_id,
        purchase_date: DateTime.now
      } }
      follow_redirect!
      assert_template "stocks/show"
    end
  end

  test "unsuccessful create missing account id" do
    assert_no_difference("Stock.count") do
      log_in_as(@user)
      get new_stock_path
      assert_template "stocks/new"
      post stocks_path, params: { stock: {
        symbol: "AMZN", share_price: 150.0, quantity_purchased: 10,
        purchase_date: DateTime.now
      } }
      assert_response :unprocessable_entity
      assert_template "stocks/new"
      assert_select "#error_explanation", count: 1
      assert_select "li", { count: 1, text: "Account can't be blank" }
    end
  end

  test "unsuccessful create account does not belong to current user" do
    assert_no_difference("Stock.count") do
      log_in_as(@user)
      get new_stock_path
      assert_template "stocks/new"
      post stocks_path, params: { stock: {
        symbol: "AMZN", share_price: 150.0, quantity_purchased: 10, account_id: accounts(:archer_account).id,
        purchase_date: DateTime.now
      } }
      assert_response :unprocessable_entity
      assert_template "stocks/new"
      assert_not flash.empty?
    end
  end

  test "unsuccessful create invalid share price" do
    assert_no_difference("Stock.count") do
      log_in_as(@user)
      get new_stock_path
      assert_template "stocks/new"
      account_id = @user.accounts.first.id
      post stocks_path, params: { stock: {
        symbol: "AMZN", share_price: 0.0, quantity_purchased: 10, account_id: account_id,
        purchase_date: DateTime.now
      } }
      assert_response :unprocessable_entity
      assert_select "#error_explanation", count: 1
      assert_select "li", { count: 1, text: "Share price must be between 1 and 999999" }
    end
  end
  test "unsuccessful create invalid quantity" do
    assert_no_difference("Stock.count") do
      log_in_as(@user)
      get new_stock_path
      assert_template "stocks/new"
      account_id = @user.accounts.first.id
      post stocks_path, params: { stock: {
        symbol: "AMZN", share_price: 1.0, quantity_purchased: 0, account_id: account_id,
        purchase_date: DateTime.now
      } }
      assert_response :unprocessable_entity
      assert_template "stocks/new"
      assert_select "#error_explanation", count: 1
      assert_select "li", { count: 1, text: "Quantity purchased must be between 1 and 9999" }
    end
  end
end
