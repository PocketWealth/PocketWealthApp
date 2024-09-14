FactoryBot.define do
  factory :account do
    association :user
    name { "test_account" }
    account_type { 1 }
    cash { 9.99 }
    description { "A test account" }
    financial_institution { "questrade" }
  end
end
