class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  after_action :verify_authorized,
               unless: -> { devise_controller? || action_name == "index" }

  after_action :verify_policy_scoped,
               if: -> { !devise_controller? && action_name == "index" }


  allow_browser versions: :modern

  stale_when_importmap_changes

  private

  def not_authorized
    redirect_to root_path, alert: "Access denied"
  end
end
