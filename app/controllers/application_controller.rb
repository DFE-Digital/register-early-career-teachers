class ApplicationController < ActionController::Base
  before_action :authenticate

  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)

  helper_method :current_user, :authenticated?

private

  def sign_in_user
    # these will build session data via begin_session even though there may not be a user
    # so we test for a user
    @sign_in_user ||= [
      PersonaSession.load_from_session(session),
      OTPSession.load_from_session(session),
      # load other auth type sessions here
    ].select { |s| s.try(:user) }.first
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
