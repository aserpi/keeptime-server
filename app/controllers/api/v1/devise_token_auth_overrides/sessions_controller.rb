module Api
  module V1
    module DeviseTokenAuthOverrides
      class SessionsController < DeviseTokenAuth::SessionsController
        include Api::V1::Concerns::JsonApi

        def render_new_error
          head :not_found
        end

        def render_create_success
          render json: @resource, serializer: Api::V1::RegisteredUserSerializer
        end

        def render_create_error_not_confirmed
          render json: { error: { code: :unconfirmed_email, status: status_s(:forbidden) } }, status: :forbidden
        end

        def render_create_error_bad_credentials
          render json: { errors: [{ code: :bad_credentials, status: status_s(:unauthorized) }] }, status: :unauthorized
        end

        def render_destroy_success
          head :ok
        end

        def render_destroy_error
          head :unprocessable_entity
        end
      end
    end
  end
end
