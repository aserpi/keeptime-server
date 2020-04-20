FactoryBot.define do
  factory :workspace do
    name { "WorkspaceName" }
    description { "Workspace\ndescription" }
    association :supervisor, factory: :registered_user
  end
end
