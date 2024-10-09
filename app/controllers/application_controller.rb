class ApplicationController < ActionController::Base
  before_action :authenticate

  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)

  helper_method :current_user, :authenticated?, :session_manager

private

  def current_user
    @current_user ||= session_manager.load_from_session
  end

  def authenticate
    return if authenticated?

    session_manager.requested_path = request.fullpath
    redirect_to(sign_in_path)
  end

  def authenticated?
    current_user.present?
  end

  def session_manager
    @session_manager ||= Sessions::SessionManager.new(session)
  end

  def login_redirect_path
    session_manager.requested_path || root_path
  end
end
