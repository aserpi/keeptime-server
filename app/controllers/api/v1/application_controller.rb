module Api
  module V1
    class ApplicationController < ActionController::API
      include Api::V1::Concerns::JsonApi
      include DeviseTokenAuth::Concerns::SetUserByToken
      include Pundit

      rescue_from Pundit::NotAuthorizedError, with: :forbidden

      private

      def forbidden
        head :forbidden
    end

      def pundit_user
        current_api_v1_registered_user
    end
  end
end
end
