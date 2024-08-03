class RemoveTransactionManagedFromAccounts < ActiveRecord::Migration[7.2]
  def change
    remove_column :accounts, :transaction_managed, :boolean
  end
end
