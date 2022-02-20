class Api::V1::WorkspaceSerializer < Api::V1::ApplicationSerializer
  set_type :workspaces

  attributes :name, :description

  belongs_to :supervisor,
             links: { self: -> (object) { url_helpers.relationships_supervisor_api_v1_workspace_path object },
                      related: -> (object) { url_helpers.api_v1_user_path object.supervisor.id } },
             serializer: Api::V1::UserSerializer

  has_many :users,
           lazy_load_data: true,
           links: { self: -> (object) { url_helpers.relationships_users_api_v1_workspace_path object },
                    related: -> (object) { url_helpers.users_api_v1_workspace_path object } }

  link(:self) { |object| url_helpers.api_v1_workspace_path object }
end
