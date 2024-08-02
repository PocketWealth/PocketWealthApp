# Create a main sample user.
User.create!(name: "PocketWealth Admin",
             email: "example@pocketwealth.com",
             password:
               "foobar",
             password_confirmation: "foobar",
             admin: true)
# Generate a bunch of additional users.
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@pocketwealth.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password:
                 password,
               password_confirmation: password)
end