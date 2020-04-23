class Api::V1::RegisteredUserSerializer < Api::V1::ApplicationSerializer
  set_type :registered_users

  attributes :name, :username

  link(:self) { |object| url_helpers.api_v1_registered_user_path object }
end
