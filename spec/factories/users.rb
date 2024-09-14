FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password" }

    factory :admin_user do
      admin { true }
    end
  end
end
