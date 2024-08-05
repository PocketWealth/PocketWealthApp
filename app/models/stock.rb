class Stock < ApplicationRecord
  belongs_to :account
  validates :symbol, presence: true, length: { maximum: 5 }
  validates :purchase_date, :account_id, presence: true
  validates :share_price, presence: true, inclusion: { in: 1..999999, message: "must be between 1 and 999999" }
  validates :quantity_purchased, presence: true, inclusion: { in: 1..9999, message: "must be between 1 and 9999" }
end
