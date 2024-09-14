require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |config|
  config.include UserHelpers
end

RSpec.describe "Stocks Controller tests" do
  let!(:user) { create(:user) }
  let!(:account) { create(:account, user: user) }
  let!(:stock) { create(:stock, account: account) }

  before do
    login(user)
  end

  it "deletes the stock" do
    expect do
      delete stock_path(stock), params: { stock: { add_stock_value_to_account: 0 } }
    end.to change { Stock.count }
    expect(response).to redirect_to(stocks_path)
    get stock_path(stock)
    expect(response).to have_http_status(:not_found)
  end

  it "deletes the stock and adds the value back to the account" do
    old_account_cash = account.cash
    stock_value = stock.quantity_purchased * stock.share_price
    expect do
      delete stock_path(stock), params: { stock: { add_stock_value_to_account: 1 } }
    end.to change { Stock.count }
    expect(response).to redirect_to(stocks_path)
    get stock_path(stock)
    expect(response).to have_http_status(:not_found)
    account.reload
    expect(account.cash).to eq(old_account_cash + stock_value)
  end

  context "with valid params" do
    it "creates a new stock" do
      post stocks_path, params: {
        stock: {
          symbol: "VSP.TO",
          purchase_date: Faker::Date.between(from: 1.year.ago, to: 2.years.ago),
          share_price: 10,
          quantity_purchased: 10,
          account_id: account.id
        }
      }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(stock_path(Stock.last))
    end
    it "updates the stock" do
      old_quantity_purchased = stock.quantity_purchased
      patch stock_path(stock), params: {
        stock: {
          quantity_purchased: 11
        }
      }
      expect(response).to have_http_status(:found)
      stock.reload
      expect(stock.quantity_purchased).to_not eq(old_quantity_purchased)
    end
  end
  context "with invalid params" do
    it "does not create a new stock" do
      post stocks_path, params: {
        stock: {
          symbol: "VSP.TO",
          purchase_date: Faker::Date.between(from: 1.year.ago, to: 2.years.ago),
          share_price: 10,
          quantity_purchased: 10,
          account_id: account.id,
          broker: "invalid"
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
    end
    it "does not update the stock" do
      patch stock_path(stock), params: {
        stock: {
          broker: "invalid"
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:edit)
    end
  end
end
