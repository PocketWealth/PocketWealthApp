class AddSymbolIdToStocks < ActiveRecord::Migration[7.2]
  def change
    add_column :stocks, :symbolId, :integer, null: false
  end
end
