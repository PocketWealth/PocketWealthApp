class RenameTypeToAccountType < ActiveRecord::Migration[7.2]
  def change
    rename_column :accounts, :type, :account_type
  end
end
