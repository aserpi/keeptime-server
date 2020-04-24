module Api
  module V1
    class WorkspacesController < Api::V1::ApplicationController
      before_action :authenticate_api_v1_registered_user!

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
