class SessionsController < ApplicationController
  skip_before_action :authenticate

  def new
    render :new
  end

  def create
    user_info = request.env['omniauth.auth']
    provider = user_info.fetch(:provider)
    # we can handle different providers here
    # OTP auth is handled in OTPSessionsController as not omniauth
    case provider
    when "developer"
      UserSession.begin_session!(session, user_info.uid, provider)
    when "dfe"
      raise provider
    else
      # TODO: handle unknown provider
      raise provider
    end

    if authenticated?
      redirect_to(login_redirect_path)
    else
      session.delete(:requested_path)
      UserSession.end_session!(session)
      redirect_to(sign_in_path)
    end
  end

  def destroy
    session.destroy # rubocop:disable Rails/SaveBang
    redirect_to root_path
  end

private

  def login_redirect_path
    # this should return the "home" location for the signed in user first perhaps?
    session.delete(:requested_path) || root_path
  end
end
