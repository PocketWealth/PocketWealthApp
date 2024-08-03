class Account < ApplicationRecord
  enum :account_type, [ :NON_REGISTERED, :RRSP, :TFSA ], default: :non_registered, validate: true
  validates :name, presence: true, length: { maximum: 50 }
  belongs_to :user
end
