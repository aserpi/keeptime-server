module Api
  module V1
    module DeviseTokenAuthOverrides
      class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
        include Api::V1::Concerns::JsonApi

        def render_validate_token_success
          render json: @resource, serializer: Api::V1::RegisteredUserSerializer
        end

        def render_validate_token_error
          render json: { errors: [{ code: :bad_credentials, status: status_s(:unauthorized) }] }, status: :unauthorized
        end
      end
    end
  end
end
