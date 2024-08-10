class UniqueUserIdInRegisteredAccountLimits < ActiveRecord::Migration[7.2]
  def change
    remove_index :registered_account_limits_2024, "user_id"
    add_index :registered_account_limits_2024, "user_id", unique: true
  end
end
