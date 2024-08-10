class RenameFhsaContributionLimitToFhsaLimit < ActiveRecord::Migration[7.2]
  def change
    rename_column "registered_account_limits_2024", :fhsa_contribution_limit, :fhsa_limit
  end
end
