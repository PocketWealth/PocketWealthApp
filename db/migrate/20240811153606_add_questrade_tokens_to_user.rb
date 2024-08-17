class AddQuestradeTokensToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :questrade_access_token, :string
    add_column :users, :questrade_refresh_token, :string
  end
end
