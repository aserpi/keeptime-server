class Api::V1::ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    @user.is_a? User
  end

  def show?
    @user.is_a? User
  end

  def create?
    @user.is_a? User
  end

  def new?
    create?
  end

  def update?
    @user.is_a? User
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
