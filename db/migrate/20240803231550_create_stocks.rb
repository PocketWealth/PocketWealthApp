class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.boolean :purchase_date
      t.decimal :share_price
      t.integer :quantity_purchased

      t.timestamps
    end
  end
end
