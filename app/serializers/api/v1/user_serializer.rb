class Api::V1::UserSerializer < Api::V1::ApplicationSerializer
  set_type :users

  attributes :name, :username
  attribute :registered do |user|
    user.registered?
  end

  has_many :workspaces,
           lazy_load_data: true,
           links: { self: -> (object) { url_helpers.api_v1_user_relationships_workspaces_path object },
                    related: -> (object) { url_helpers.api_v1_user_workspaces_path object } }

  link(:self) { |object| url_helpers.api_v1_user_path object }
end
