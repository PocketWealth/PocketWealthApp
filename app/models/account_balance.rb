class AccountBalance < ApplicationRecord
  self.table_name = "account_balances_#{Date.current.year}"
  belongs_to :account
end
