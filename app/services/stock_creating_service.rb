class StockCreatingService
  def initialize(user:, account_updating_service:)
    @user = user
    @account_updating_service = account_updating_service
  end

  def create_stock(stock_params, update_account)
    stock = Stock.new(stock_params)
    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless stock.valid?
      update_account_with_stock_value(stock_params) if update_account
    end
    stock
  end

  def update_account_with_stock_value(stock_params)
    account = Account.find(stock_params[:account_id])
    stock_value = stock_params[:share_price].to_d * stock_params[:quantity_purchased].to_d
    account = @account_updating_service.remove_cash_from_account(account, stock_value)
    raise ActionController::BadRequest unless account.valid?
    return if account.account_type == "NON_REGISTERED"
    @account_updating_service.update_account_contributions(account, stock_value)
  end
end
