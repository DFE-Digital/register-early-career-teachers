class SessionsController < ApplicationController
  skip_before_action :authenticate

  def new
    render :new
  end

  def create
    user_info = request.env['omniauth.auth']
    provider = user_info.fetch(:provider)

    # NOTE: OTP authentication is handled in OTPSessionsController as it is not omniauth
    case provider
    when "developer"
      session_manager.begin_session!(user_info.uid, provider)
    when "dfe"
      raise provider
    else
      # TODO: handle unknown provider
      raise provider
    end

    if authenticated?
      redirect_to(login_redirect_path)
    else
      session_manager.end_session!
      redirect_to(sign_in_path)
    end
  end

  def destroy
    session_manager.end_session!
    redirect_to root_path
  end
end
