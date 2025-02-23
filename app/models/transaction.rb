class Transaction < ApplicationRecord
  self.table_name = "transactions_#{Date.current.year}"
  belongs_to :from_account, class_name: "Account", foreign_key: "from_account_id"
  belongs_to :to_account, class_name: "Account", foreign_key: "to_account_id"

  validates :transaction_type, presence: true, length: { maximum: 15 }

  validates :funds_value_added, inclusion: { in: 0..999_999, message: "must be between 0 and 999999" }
  validates :funds_value_removed, inclusion: { in: 0..999_999, message: "must be between 0 and 999999" }
  validates :funds_value_transferred, inclusion: { in: 0..999_999, message: "must be between 0 and 999999" }

  validates :stock_value_added, inclusion: { in: 0..999_999, message: "must be between 0 and 999999" }
  validates :stock_value_removed, inclusion: { in: 0..999_999, message: "must be between 0 and 999999" }
  validates :stock_value_transferred, inclusion: { in: 0..999_999, message: "must be between 0 and 999999" }

  validates :from_account_id, presence: true
  validates :to_account_id, presence: true

  validates :transaction_date, presence: true
end
