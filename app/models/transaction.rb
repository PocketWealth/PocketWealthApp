class Transaction < ApplicationRecord
  self.table_name = "transactions_#{Date.current.year}"
  belongs_to :account, class_name: "Account", foreign_key: "from_account_id"
  belongs_to :account, class_name: "Account", foreign_key: "to_account_id"
end
