class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  after_action :verify_authorized,
               unless: -> { devise_controller? || action_name == "index" }

  after_action :verify_policy_scoped,
               if: -> { !devise_controller? && action_name == "index" }


  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def not_authorized
    redirect_to root_path, alert: "Access denied"
  end
end

# class ApplicationController < ActionController::Base
#   include Pundit::Authorization

#   after_action :verify_authorized, unless: :devise_controller?
#   after_action :verify_policy_scoped, if: -> { !devise_controller? && action_name == "index" }
# end
