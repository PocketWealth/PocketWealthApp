module TransactionsHelper
  def transaction_value_sum(transaction)
    sum = 0
    sum += transaction.funds_value_added
    sum += transaction.funds_value_removed
    sum += transaction.funds_value_transferred
    sum += transaction.stock_value_added
    sum += transaction.stock_value_removed
    sum + transaction.stock_value_transferred
  end
end
