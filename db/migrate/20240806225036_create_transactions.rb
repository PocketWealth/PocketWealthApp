class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions_2024 do |t|
      t.string :type
      t.decimal :funds_value_added, default: "0.0"
      t.decimal :funds_value_removed, default: "0.0"
      t.decimal :funds_value_transferred, default: "0.0"
      t.string :stock_symbol
      t.integer :stock_quantity, default: "0"
      t.decimal :stock_value_added, default: "0.0"
      t.decimal :stock_value_removed, default: "0.0"
      t.decimal :stock_value_transferred, default: "0.0"
      t.integer :from_account_id, null: false
      t.integer :to_account_id
      t.index [ "from_account_id" ], name: "index_transactions_on_from_account_id"
      t.index [ "to_account_id" ], name: "index_transactions_on_to_account_id"

      t.timestamps
    end
    add_foreign_key :transactions_2024, :accounts, column: :from_account_id, primary_key: "id"
    add_foreign_key :transactions_2024, :accounts, column: :to_account_id, primary_key: "id"
  end
end
