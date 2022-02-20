module Api
  module V1
    module DeviseTokenAuthOverrides
      class SessionsController < DeviseTokenAuth::SessionsController
        include Api::V1::Concerns::JsonApi

        def render_new_error
          head :not_found
        end

        def render_create_success
          render json: Api::V1::UserSerializer.new(@resource).serializable_hash
        end

        def render_create_error_not_confirmed
          render json: { error: { code: :unconfirmed_email, status: status_s(:forbidden) } }, status: :forbidden
        end

        def render_create_error_bad_credentials
          render json: { errors: [{ code: :bad_credentials, status: status_s(:unauthorized) }] }, status: :unauthorized
        end

        def render_destroy_success
          head :no_content
        end

        def render_destroy_error
          head :unprocessable_entity
        end
      end
    end
  end
end
