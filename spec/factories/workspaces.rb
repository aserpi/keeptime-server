FactoryBot.define do
  factory :workspace do
    name { "WorkspaceName" }
    description { "Workspace\ndescription" }
    association :supervisor, factory: :registered_user
    registered_users { [supervisor] }
  end

  factory :second_workspace, class: Workspace do
    name { "Second workspace" }
    description { "second DeScRiPtIoN!" }
    association :supervisor, factory: :second_user
    registered_users { [supervisor] }
  end
end
