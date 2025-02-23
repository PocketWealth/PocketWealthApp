class UpdateDefaultForTransactionDate < ActiveRecord::Migration[7.2]
  def change
    change_column_default :transactions_2025, :transaction_date, -> { 'NOW' }
  end
end
