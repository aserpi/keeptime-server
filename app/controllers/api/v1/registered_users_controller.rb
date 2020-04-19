module Api
  module V1
    class RegisteredUsersController < Api::V1::ApplicationController
      before_action :authenticate_api_v1_registered_user!
      before_action :set_registered_user, only: :show

      def show
        render json: @registered_user
      end

      private

      def set_registered_user
        @registered_user = RegisteredUser.find(params[:id])
      end
    end
  end
end
