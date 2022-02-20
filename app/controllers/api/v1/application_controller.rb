require 'pagy/extras/metadata'

module Api
  module V1
    class ApplicationController < ActionController::API
      include Api::V1::Concerns::JsonApi
      include DeviseTokenAuth::Concerns::SetUserByToken
      include Pagy::Backend
      include Pundit

      # Prevents information leakage
      # Users must not know if a record exists or not, if they have no access to it
      rescue_from ActiveRecord::RecordNotFound, with: :forbidden
      rescue_from Pundit::NotAuthorizedError, with: :forbidden

      protected

      def pagy_api(collection, vars = {})
        pagy, records = pagy(collection, vars)
        metadata = pagy_metadata(pagy)

        links = { first: metadata[:first_url],
                  prev: metadata[:prev] ? metadata[:prev_url] : nil,
                  next: metadata[:next] ? metadata[:next_url] : nil,
                  last: metadata[:last_url] }

        [records, links]
      end

      private

      def forbidden
        head :forbidden
      end

      def pundit_user
        current_api_v1_user
      end
    end
  end
end
