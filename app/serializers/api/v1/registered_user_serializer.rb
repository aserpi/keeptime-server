class Api::V1::RegisteredUserSerializer < Api::V1::ApplicationSerializer
  set_type :registered_users

  attributes :name, :username

  has_many :workspaces,
           lazy_load_data: true,
           links: { self: -> (object) { url_helpers.api_v1_registered_user_relationships_workspaces_path object },
                    related: -> (object) { url_helpers.api_v1_registered_user_workspaces_path object } }

  link(:self) { |object| url_helpers.api_v1_registered_user_path object }
end
