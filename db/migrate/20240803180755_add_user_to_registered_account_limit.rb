class AddUserToRegisteredAccountLimit < ActiveRecord::Migration[7.2]
  def change
    add_reference :registered_account_limits_2024, :user, null: false, foreign_key: true
  end
end
