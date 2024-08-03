class CreateRegisteredAccountLimits < ActiveRecord::Migration[7.2]
  def change
    create_table :registered_account_limits_2024 do |t|
      t.decimal :tfsa_limit
      t.decimal :rrsp_limit
      t.decimal :tfsa_contributions
      t.decimal :rrsp_contributions

      t.timestamps
    end
  end
end
