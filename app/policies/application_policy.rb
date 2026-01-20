class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # Default deny for write actions unless overridden
  def create?  = false
  def update?  = false
  def destroy? = false

  # Read actions: allow by default (you can keep stricter if needed)
  def index? = true
  def show?  = true

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    # Everyone can see everything
    def resolve
      scope.all
    end
  end
end
