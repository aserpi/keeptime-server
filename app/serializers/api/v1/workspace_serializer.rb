class Api::V1::WorkspaceSerializer < Api::V1::ApplicationSerializer
  set_type :workspaces

  attributes :name, :description

  belongs_to :supervisor,
             links: { related: -> (object) { url_helpers.api_v1_registered_user_path object.supervisor.id } },
             serializer: Api::V1::RegisteredUserSerializer

  has_many :placeholder_users,
           lazy_load_data: true,
           links: { self: -> (object) { url_helpers.relationships_placeholder_users_api_v1_workspace_path object },
                    related: -> (object) { url_helpers.placeholder_users_api_v1_workspace_path object } }

  has_many :registered_users,
           lazy_load_data: true,
           links: { self: -> (object) { url_helpers.relationships_registered_users_api_v1_workspace_path object },
                    related: -> (object) { url_helpers.registered_users_api_v1_workspace_path object } }

  link(:self) { |object| url_helpers.api_v1_workspace_path object }
end
