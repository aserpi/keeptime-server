module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :set_user, only: [:show, :workspaces]

      def show
        render json: @user
      end

      def workspaces
        pagy, workspaces = pagy(@user.workspaces)

        render json: workspaces
      end

      private

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
