class ChangePurchaseDateFromBooleanToDatetime < ActiveRecord::Migration[7.2]
  def change
    change_column :stocks, :purchase_date, :datetime, null: false
    change_column :stocks, :symbol, :string, null: false
    change_column :stocks, :share_price, :decimal, null: false
    change_column :stocks, :quantity_purchased, :integer, null: false
  end
end
