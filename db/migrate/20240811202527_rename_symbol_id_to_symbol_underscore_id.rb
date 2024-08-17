class RenameSymbolIdToSymbolUnderscoreId < ActiveRecord::Migration[7.2]
  def change
    rename_column :stocks, :symbolId, :symbol_id
  end
end
