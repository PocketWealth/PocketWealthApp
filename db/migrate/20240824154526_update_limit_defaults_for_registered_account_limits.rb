class UpdateLimitDefaultsForRegisteredAccountLimits < ActiveRecord::Migration[7.2]
  def change
    change_column :registered_account_limits_2025, :tfsa_limit, :decimal,  default: 0.0, null: false
    change_column :registered_account_limits_2025, :rrsp_limit, :decimal, default: 0.0, null: false
  end
end
