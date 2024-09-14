FactoryBot.define do
  factory :registered_account_limit do
    association :user
    tfsa_limit { 1000 }
    rrsp_limit { 1000 }
    fhsa_limit { 1000 }
    tfsa_contributions { 1000 }
    rrsp_contributions { 1000 }
    fhsa_contributions { 1000 }
  end
end
