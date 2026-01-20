class ReportPolicy < ApplicationPolicy
  def view?
    user.present?
  end
end