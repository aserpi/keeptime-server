FactoryBot.define do
  factory :user do
    email { "example@example.com" }
    name { "Name Surname" }
    password { "userPassword" }
    username  { "username" }
  end

  factory :second_user, class: User do
    email { "second@example.com"}
    name { "Second Name Surname" }
    password { "userPassword" }
    username { "secondUsername" }
  end

  factory :unregistered_user, class: User do
    name { "Unregistered User" }
    username { "unregisteredUser" }
  end
end
