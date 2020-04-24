FactoryBot.define do
  factory :registered_user do
    email { "example@example.com" }
    name { "Name Surname" }
    password { "userPassword" }
    username  { "username" }
  end

  factory :second_user, class: RegisteredUser do
    email { "second@example.com"}
    name { "Second Name Surname" }
    password { "userPassword" }
    username { "secondUsername" }
  end
end
