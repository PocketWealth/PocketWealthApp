class AddBrokerToStocks < ActiveRecord::Migration[7.2]
  def change
    add_column :stocks, :broker, :string
  end
end
