class AddFhsaToRegisteredAccountLimits < ActiveRecord::Migration[7.2]
  def change
    add_column "registered_account_limits_2024", :fhsa_contribution_limit, :decimal, null: true
    add_column "registered_account_limits_2024", :fhsa_contributions, :decimal, default: 0.0, null: false
  end
end
