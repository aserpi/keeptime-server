FactoryBot.define do
  factory :registered_user do
    email { "example@example.com" }
    name { "Name Surname" }
    password { "userPassword" }
    username  { "username" }
  end
end
