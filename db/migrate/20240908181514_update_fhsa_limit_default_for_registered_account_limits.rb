class UpdateFhsaLimitDefaultForRegisteredAccountLimits < ActiveRecord::Migration[7.2]
  def change
    change_column :registered_account_limits_2024, :fhsa_limit, :decimal, default: 0.0, null: false
  end
end
