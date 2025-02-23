class AddTransactionDateToTransaction < ActiveRecord::Migration[7.2]
  def change
    add_column :transactions_2025, :transaction_date, :datetime, default: DateTime.now, null: false
  end
end
