class SessionsController < ApplicationController
  skip_before_action :authenticate

  def new
    render :new
  end

  def create
    user_info = request.env['omniauth.auth']
    provider = user_info.fetch(:provider).to_s

    # NOTE: OTP authentication is handled in OTPSessionsController as it is not omniauth
    # FIXME: invetigate treating all the providers as symbols rather than strings,
    #        especially 'developer'
    case provider
    when "developer"
      # FIXME: do this using the SessionManager
      if params["appropriate_body_id"]
        session["appropriate_body_id"] = params["appropriate_body_id"]
      end

      session_manager.begin_session!(user_info)
    when "dfe"

      # session_manager.being_session(user_info.uid, ...)
      session_manager.begin_session!(user_info)
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
