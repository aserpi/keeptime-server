module Api
  module V1
    class RegisteredUserSerializer < Api::V1::ApplicationSerializer
      attributes :name, :username

      link(:self) { api_v1_registered_user_url(object, format: :json) }

      def same_user?
        object == scope
      end
    end
  end
end
