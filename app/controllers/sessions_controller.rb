class SessionsController < ApplicationController
  skip_before_action :authenticate

  def new
    render :new
  end

  def create
    user_info = request.env['omniauth.auth']

    # NOTE: OTP authentication is handled in OTPSessionsController as it is not omniauth
    case user_info.provider
    when "developer"
      dfe = ActiveModel::Type::Boolean.new.cast(params['dfe'])

      dfe ? begin_otp_session(user_info) : begin_persona_session(user_info)
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

private

  def begin_persona_session(user_info)
    session_manager.begin_persona_session!(
      user_info.info.email,
      name: user_info.info.name,
      appropriate_body_id: params["appropriate_body_id"].presence,
      school_urn: params["school_urn"].presence
    )
  end

  def begin_otp_session(user_info)
    session_manager.begin_otp_session!(user_info.info.email)
  end
end
