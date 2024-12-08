class ApplicationController < ActionController::Base
  class UnredirectableError < StandardError; end

  before_action :authenticate
  before_action :set_sentry_user

  include Pagy::Backend

  helper_method :current_user, :authenticated?, :session_manager

private

  def require_admin
    # This method is used by Blazer to restrict access. See config/blazer.yml
    redirect_to('/sign-in') unless Admin::Access.new(current_user).can_access?
  end

  def ab_home_path
    ab_teachers_path if current_user.appropriate_body_user?
  end

  def school_home_path
    schools_ects_home_path if current_user.school_user?
  end

  def admin_home_path
    admin_path if current_user&.dfe_user?
  end

  def authenticate
    return if authenticated?

    session_manager.requested_path = request.fullpath
    redirect_to(sign_in_path)
  end

  def authenticated?
    current_user.present?
  end

  def current_user
    @current_user ||= session_manager.load_from_session
  end

  def login_redirect_path
    session_manager.requested_path || admin_home_path || ab_home_path || school_home_path || fail(UnredirectableError)
  end

  def session_manager
    @session_manager ||= Sessions::SessionManager.new(session)
  end

  def set_sentry_user
    Sentry.set_user(email: current_user&.email)
  end
end
