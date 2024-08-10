require "test_helper"

class StocksIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @stock = stocks(:michael_stock)
  end

  test "index as logged in user" do
    log_in_as(@user)
    get stocks_path
    assert_template "stocks/index"
    assert_select "td", text: @stock.symbol, count: 1
  end
  test "index as logged out user" do
    get stocks_path
    assert_response :see_other
    assert_redirected_to login_url
    follow_redirect!
    assert_template "sessions/new"
  end
end
