class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern
  helper_method :authenticated?, :current_user
end
