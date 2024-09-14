class SymbolIdNullableOnStocks < ActiveRecord::Migration[7.2]
  def change
    change_column :stocks, :symbol_id, :string, null: true
  end
end
