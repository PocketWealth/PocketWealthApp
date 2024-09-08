class RegisteredAccountLimit < ApplicationRecord
  validates :tfsa_limit, :rrsp_limit, :fhsa_limit, :tfsa_contributions, :rrsp_contributions, :fhsa_contributions, numericality: { greater_than_or_equal_to: 0 }
  self.table_name = "registered_account_limits_#{Date.current.year}"
  belongs_to :user
end
