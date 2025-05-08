class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern
  helper_method :authenticated?, :current_user
  before_action :ensure_username_present

  private

  def ensure_username_present
    return unless current_user
    if current_user.username.blank? && request.path != edit_profile_path(current_user)
      redirect_to edit_profile_path(current_user), alert: "Please choose a username to continue."
    end
  end
  
end
