FactoryBot.define do
  factory :api_key do
    association :user
    provider { "questrade" }
    access_token { "access_token" }
    refresh_token { "refresh_token" }
    url { "https://api05.iq.questrade.com/" }
  end
end
