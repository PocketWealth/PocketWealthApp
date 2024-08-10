class CreateAccountBalances < ActiveRecord::Migration[7.2]
  def change
    create_table :account_balances_2024 do |t|
      t.decimal :account_balance
      t.integer "account_id", null: false
      t.index ["account_id"], name: "index_account_balances_on_account_id"
      t.timestamps
    end
    add_foreign_key :account_balances_2024, :accounts
  end
end
