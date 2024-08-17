class StockDeletingService
  def delete_stock(stock, stock_params)
    if stock_params[:add_stock_value_to_account] == "1"
      account = stock.account
      stock_value = stock.quantity_purchased * stock.share_price
      current_account_value = account.cash || 0.0
      new_account_value = current_account_value + stock_value
      account.cash = new_account_value
      account.save
    end

    stock.destroy!
  end
end
