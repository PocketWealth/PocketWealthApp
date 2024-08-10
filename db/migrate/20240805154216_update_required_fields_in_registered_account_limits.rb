class UpdateRequiredFieldsInRegisteredAccountLimits < ActiveRecord::Migration[7.2]
  def change
    change_column :registered_account_limits_2024, :tfsa_limit, :decimal, null: true
    change_column :registered_account_limits_2024, :rrsp_limit, :decimal, null: true
    change_column :registered_account_limits_2024, :tfsa_contributions, :decimal, default: 0.0, null: false
    change_column :registered_account_limits_2024, :rrsp_contributions, :decimal, default: 0.0, null: false
  end
end
