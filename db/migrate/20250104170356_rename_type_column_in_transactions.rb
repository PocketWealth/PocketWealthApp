class RenameTypeColumnInTransactions < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions_2025, :type, :transaction_type
  end
end
