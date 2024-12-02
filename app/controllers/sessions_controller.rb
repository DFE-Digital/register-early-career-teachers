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
      session_manager.appropriate_body_id = params["appropriate_body_id"]
      session_manager.school_urn = params["school_urn"]
      session_manager.begin_developer_session!(user_info.info.email)
    when "dfe_sign_in"
      session_manager.begin_dfe_sign_in_session!(user_info)
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
