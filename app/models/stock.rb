class Stock < ApplicationRecord
  before_validation :remove_whitespaces

  belongs_to :account
  enum :broker, [:QUESTRADE], validate: { allow_nil: true }
  validates :symbol, presence: true, length: { maximum: 10 }
  validates :purchase_date, :account_id, presence: true
  validates :share_price, presence: true, inclusion: { in: 1..999_999, message: "must be between 1 and 999999" }
  validates :quantity_purchased, presence: true, inclusion: { in: 1..9999, message: "must be between 1 and 9999" }

  private

    def remove_whitespaces
      self.symbol_id.strip!
      self.symbol_id = nil if symbol_id.empty?
    end
end
