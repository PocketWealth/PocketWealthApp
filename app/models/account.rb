class Account < ApplicationRecord
  enum :account_type, %i[NON_REGISTERED RRSP TFSA FHSA], default: :non_registered, validate: true
  validates :name, presence: true, length: { maximum: 50 }
  belongs_to :user
  has_many :stocks
  has_many :account_balances
end
