class RegisteredAccountLimit < ApplicationRecord
  self.table_name = "registered_account_limits_#{Date.current.year}"
  belongs_to :user
end
