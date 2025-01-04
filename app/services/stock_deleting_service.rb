class StockDeletingService
  def initialize(account_updating_service:)
    @account_updating_service = account_updating_service
  end
  def delete_stock(stock, stock_params)
    ActiveRecord::Base.transaction do
      if stock_params[:add_stock_value_to_account]
        account = stock.account
        stock_value = stock.quantity_purchased * stock.share_price
        raise ActionController::BadRequest unless @account_updating_service.add_cash_to_account(account, stock_value)
      end
      stock.destroy!
    end
  end
end
