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
    it "creates a stock and updates the account balance" do
      create(:registered_account_limit, user: user)
      previous_account_balance = account.cash
      post stocks_path, params: {
        stock: {
          symbol: "VSP.TO",
          purchase_date: Faker::Date.between(from: 1.year.ago, to: 2.years.ago),
          share_price: 10,
          quantity_purchased: 10,
          account_id: account.id,
          update_account: "1"
        }
      }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(stock_path(Stock.last))
      account.reload
      expect(account.cash).to eq(previous_account_balance - 100)
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
  context "when doing a full stock transfer" do
    context "with valid params" do
      it "transfers the stock in full to the account" do
        to_account = create(:account, user: user)
        patch edit_transfer_stock_path(stock), params: {
          stock: {
            transfer_quantity: stock.quantity_purchased,
            to_account_id: to_account.id
          }
        }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(stock_path(stock))
        stock.reload
        expect(stock.account).to eq(to_account)
        expect(account.stocks.count).to eq(0)
        expect(to_account.stocks[0]).to eq(stock)
      end
    end
    context "with invalid params" do
      it "does not transfer the stock" do
        patch edit_transfer_stock_path(stock), params: {
          stock: {
            transfer_quantity: stock.quantity_purchased,
            to_account_id: "3"
          }
        }
        expect(response).to have_http_status(:bad_request)
        stock.reload
        expect(stock.account).to eq(account)
      end
    end
  end
  context "when doing a full stock transfer" do
    context "with valid params" do
      it "partially transfer the stock to the account" do
        stock_quantity = stock.quantity_purchased
        to_account = create(:account, user: user)
        patch edit_transfer_stock_path(stock), params: {
          stock: {
            transfer_quantity: 1,
            to_account_id: to_account.id
          }
        }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(stock_path(stock))
        stock.reload
        expect(stock.account).to eq(account)
        expect(account.stocks.count).to eq(1)
        expect(account.stocks[0].quantity_purchased).to eq(stock_quantity-1)
        expect(to_account.stocks.count).to eq(1)
        new_stock = to_account.stocks[0]
        expect(new_stock.quantity_purchased).to eq(1)
        expect(new_stock.share_price).to eq(stock.share_price)
        expect(new_stock.symbol).to eq(stock.symbol)
        expect(new_stock.symbol_id).to eq(stock.symbol_id)
        expect(new_stock.broker).to eq(stock.broker)
      end
    end
    context "with invalid params" do
      it "does not transfer the stock" do
        to_account = create(:account, user: user)
        previous_quantity = stock.quantity_purchased
        patch edit_transfer_stock_path(stock), params: {
          stock: {
            transfer_quantity: stock.quantity_purchased + 1,
            to_account_id: to_account.id
          }
        }
        expect(response).to have_http_status(:bad_request)
        stock.reload
        expect(stock.account).to eq(account)
        expect(stock.quantity_purchased).to eq(previous_quantity)
      end
    end
  end
end
