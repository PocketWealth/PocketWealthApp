class RemoveQuestradeAttributesFromUser < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :questrade_access_token
    remove_column :users, :questrade_refresh_token
  end
end
