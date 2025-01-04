class StockTransferService
  def initialize(user:, account_updating_service:)
    @user = user
    @account_updating_service = account_updating_service
  end
  STOCK_TRANSFER_UPDATE_CONTRIBUTIONS = {
    "NON_REGISTERED" => {
      "NON_REGISTERED" => false,
      "RRSP" => true,
      "TFSA" => true,
      "FHSA" => true
    },
    "RRSP" => {
      "NON_REGISTERED" => false,
      "RRSP" => false,
      "TFSA" => true,
      "FHSA" => true
    },
    "TFSA" => {
      "NON_REGISTERED" => false,
      "RRSP" => true,
      "TFSA" => false,
      "FHSA" => true
    },
    "FHSA" => {
      "NON_REGISTERED" => false,
      "RRSP" => true,
      "TFSA" => true,
      "FHSA" => false
    }
  }.freeze
  def transfer_stock(stock:, to_account_id:, quantity:)
    from_account = stock.account
    to_account = @user.accounts.find_by(id: to_account_id)
    raise ActionController::BadRequest unless
      valid_transfer_request?(from_account: from_account, to_account: to_account, stock: stock, quantity: quantity)
    ActiveRecord::Base.transaction do
      stock_value = quantity * stock.share_price
      if stock.quantity_purchased == quantity
        full_transfer(stock: stock, to_account: to_account)
      else
        partial_transfer(stock: stock, quantity: quantity, to_account: to_account)
      end
      if should_update_to_account_contributions?(from_account, to_account)
        @account_updating_service.update_account_contributions(to_account, stock_value)
      end
    end
    stock
  end

  def full_transfer(stock:, to_account:)
    ActiveRecord::Base.transaction do
      stock.account = to_account
      stock.save!
    end
  end

  def partial_transfer(stock:, quantity:, to_account:)
    ActiveRecord::Base.transaction do
      stock.quantity_purchased = stock.quantity_purchased - quantity
      new_stock = stock.dup
      new_stock.account = to_account
      new_stock.purchase_date = DateTime.current
      new_stock.quantity_purchased = quantity
      stock.save!
      new_stock.save!
    end
  end

  def valid_transfer_request?(from_account:, to_account:, quantity:, stock:)
    return false if from_account.nil? || to_account.nil?
    return false if from_account == to_account
    return false unless valid_quantity?(stock, quantity)
    return false unless (quantity * stock.share_price).positive?
    true
  end

  def valid_quantity?(stock, quantity)
    quantity.positive? && quantity <= stock.quantity_purchased
  end

  def should_update_to_account_contributions?(from_account, to_account)
    STOCK_TRANSFER_UPDATE_CONTRIBUTIONS[from_account.account_type][to_account.account_type]
  end
end
