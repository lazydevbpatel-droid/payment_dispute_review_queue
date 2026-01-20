class DisputePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  # Only admin can create/update/destroy (adjust as you like)
  def create?
    user.admin?
  end

  def update?
    user.admin? || user.reviewer?
  end

  def destroy?
    user.admin?
  end

  def review?
    user.admin? || user.reviewer?
  end

  def approve?
    user.admin?
  end

  def transition?
    user.admin? || user.reviewer?
  end

  def reopen?
    user.admin? || user.reviewer?
  end
end
