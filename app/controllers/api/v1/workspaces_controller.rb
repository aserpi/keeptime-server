module Api
  module V1
    class WorkspacesController < Api::V1::ApplicationController
      after_action :verify_authorized, if: -> { Rails.env.development? || Rails.env.test? }

      def index
      end

      def show
      end

      def create
      end

      def update
      end

      def destroy
      end
    end
  end
end
