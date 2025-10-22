class ApplicationController < ActionController::Base
  before_action :set_lab_headers

  helper_method :current_user, :user_signed_in?, :admin_user?, :lab_mode?

  private

  def set_lab_headers
    return unless lab_mode?

    response.set_header("X-Lab-Mode", "enabled")
  end

  def lab_mode?
    Rails.application.config.x.lab_mode_enabled
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def admin_user?
    current_user&.admin?
  end

  def require_login
    return if user_signed_in?

    redirect_to new_session_path, alert: "Please sign in to continue."
  end

  def require_admin
    return if admin_user?

    redirect_to root_path, alert: "The page you were looking for could not be found."
  end
end
