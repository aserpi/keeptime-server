class Api::V1::WorkspacePolicy < Api::V1::ApplicationPolicy
  def initialize(user, workspace)
    @user = user
    @workspace = workspace
  end

  def show?
    @workspace.registered_users.exists?(@user.id)
  end

  def update?
    @workspace.supervisor == @user
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @scope.joins('INNER JOIN "registered_users_workspaces" AS "r" ON "workspaces"."id" = "r"."workspace_id"')
          .where(r: { registered_user_id: @user.id })
    end
  end
end
