module Api
  module V1
    class WorkspacesController < Api::V1::ApplicationController  # TODO
      after_action :verify_authorized, if: -> { Rails.env.development? || Rails.env.test? }
      before_action(except: [:index, :create]) do
        @workspace = Workspace.find(params[:id])
        authorize [:api, :v1, @workspace]
      end
      before_action(only: [:index, :create]) { authorize [:api, :v1, Workspace] }

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
            check_forbidden_relationships(:users, :supervisor)
          return
        end

        workspace = Workspace.new(workspace_params)
        workspace.users = [current_api_v1_user]
        workspace.supervisor = current_api_v1_user

        if workspace.save
          render json: Api::V1::WorkspaceSerializer.new(workspace).serializable_hash, status: :created
        else
          render_error workspace
        end
      end

      def update
        unless check_type(:workspaces, params) &&
            check_update_id(@workspace) &&
            check_forbidden_relationships(:supervisor, users)
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

      def index_registered_users
        render json: Api::V1::UserSerializer.new(@workspace.users, is_collection: true)
      end

      def show_supervisor
        render json: Api::V1::UserSerializer.new(@workspace.supervisor).serializable_hash
      end

      def create_users
        ids = relation_update_ids(:users)
        return unless ids

        @workspace.user_ids << ids  # TODO
        render json: Api::V1::UserSerializer.new(@workspace.users, is_collection: true).serializable_hash
      end

      def update_users
        render json: { errors: [{ code: :relationship_replacement, status: status_s(:forbidden) }] }, status: forbidden
      end

      def update_supervisor
        return unless check_type(:users, params)
        @workspace.update!(supervisor_id: Integer(params.require(:data).require(:id)))
        head :no_content
      rescue ArgumentError, ActiveRecord::RecordInvalid
        render json: { errors: [{ code: :wrong_id,
                                  source: "/data/id",
                                  status: status_s(:bad_request) }] }, status: :bad_request
      end

      def destroy_users
        ids = relation_update_ids(:users)
        return unless ids

        @workspace._user_ids.delete ids
        render json: Api::V1::UserSerializer.new(@workspace.users, is_collection: true).serializable_hash
      end

      private

      def workspace_params
        params.require(:data).require(:attributes).permit(:description, :name)
      end
    end
  end
end
