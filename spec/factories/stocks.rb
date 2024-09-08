FactoryBot.define do
  factory :stock do
    association :account
    symbol { "VFV" }
    purchase_date { Faker::Date.between(from: 1.year.ago, to: 2.years.ago) }
    share_price { Faker::Commerce.price }
    quantity_purchased { 100 }
    symbol_id { "VFV.TO" }
    broker { :QUESTRADE }
  end
end
