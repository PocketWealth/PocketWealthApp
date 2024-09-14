FactoryBot.define do
  factory :account do
    association :user
    name { "test_account" }
    account_type { :NON_REGISTERED }
    cash { 9.99 }
    description { "A test account" }
    financial_institution { "questrade" }
    factory :rrsp_account do
      account_type { :RRSP }
    end
    factory :tfsa_account do
      account_type { :TFSA }
    end
    factory :fhsa_account do
      account_type { :FHSA }
    end
  end
end
