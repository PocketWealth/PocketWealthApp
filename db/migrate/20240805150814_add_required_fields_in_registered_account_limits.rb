class AddRequiredFieldsInRegisteredAccountLimits < ActiveRecord::Migration[7.2]
  def change
    change_column :registered_account_limits_2024, :tfsa_limit, :decimal, null: false
    change_column :registered_account_limits_2024, :rrsp_limit, :decimal, null: false
    change_column :registered_account_limits_2024, :tfsa_contributions, :decimal, null: false
    change_column :registered_account_limits_2024, :rrsp_contributions, :decimal, null: false
  end
end
