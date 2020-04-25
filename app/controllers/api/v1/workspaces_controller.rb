module Api
  module V1
    class WorkspacesController < Api::V1::ApplicationController
      after_action :verify_authorized, if: -> { Rails.env.development? || Rails.env.test? }
      before_action(only: [:show, :update, :destroy]) { @workspace = Workspace.find(params[:id]) }
      before_action(only: [:index, :create]) { authorize [:api, :v1, Workspace] }
      before_action(only: [:show, :update, :destroy]) { authorize [:api, :v1, @workspace] }

      def index
        records, links = pagy_api(policy_scope([:api, :v1, Workspace]))
        render json: Api::V1::WorkspaceSerializer.new(records, is_collection: true, links: links).serializable_hash
      end

      def show
        render json: Api::V1::WorkspaceSerializer.new(@workspace).serializable_hash
      end

      def create
        unless check_type(:workspaces, params) &&
            check_client_generated_id &&
            check_forbidden_relationships(:placeholder_users, :registered_users, :supervisor)
          return
        end

        workspace = Workspace.new(workspace_params)
        workspace.registered_users = [current_api_v1_registered_user]
        workspace.supervisor = current_api_v1_registered_user

        if workspace.save
          render json: Api::V1::WorkspaceSerializer.new(workspace).serializable_hash, status: :created
        else
          render_error workspace
        end
      end

      def update
        unless check_type(:workspaces, params) &&
            check_update_id(@workspace) &&
            check_forbidden_relationships(:supervisor, :placeholder_users, :registered_users)
          return
        end

        if @workspace.update(workspace_params)
          render json: Api::V1::WorkspaceSerializer.new(@workspace).serializable_hash, status: :ok
        else
          render_error @workspace
        end
      end

      def destroy
        if @workspace.destroy
          head :no_content
        else
          render error: @workspace
        end
      end

      private

      def workspace_params
        params.require(:data).require(:attributes).permit(:description, :name)
      end
    end
  end
end
