class Api::V1::WorkspacePolicy < Api::V1::ApplicationPolicy
  def initialize(user, workspace)
    @user = user
    @workspace = workspace
  end

  def show?
    @workspace.users.exists?(@user.id)
  end

  def update?
    @workspace.supervisor == @user
  end

  def index_users?
    show?
  end

  def show_supervisor?
    show?
  end

  def create_users?
    update?
  end

  def update_users?
    update?
  end

  def update_supervisor?
    update?
  end

  def destroy_users?
    update?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @scope.joins('INNER JOIN "users_workspaces" AS "r" ON "workspaces"."id" = "r"."workspace_id"')
          .where(r: { user_id: @user.id })
    end
  end
end
