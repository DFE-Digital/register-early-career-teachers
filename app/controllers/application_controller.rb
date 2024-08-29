class ApplicationController < ActionController::Base
  before_action :authenticate

  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)

  helper_method :current_user, :authenticated?

private

  def sign_in_user
    @sign_in_user ||= load_user_session
  end

  def load_user_session
    # we build session data via begin_session even though there may not be a user
    # so we test for a user
    user_session = UserSession.load_from_session(session)
    return if user_session.blank?
    return if user_session.user.blank?

    user_session
  end

  def current_user
    @current_user ||= sign_in_user.user if sign_in_user
  end

  def save_requested_path
    session[:requested_path] = request.fullpath
  end

  def save_requested_path_and_redirect
    save_requested_path
    redirect_to(sign_in_path)
  end

  def authenticate
    save_requested_path_and_redirect unless authenticated?
  end

  def authenticated?
    current_user.present?
  end
end
