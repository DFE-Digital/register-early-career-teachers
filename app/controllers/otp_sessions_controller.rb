class OTPSessionsController < ApplicationController
  skip_before_action :authenticate
  before_action :build_otp_form, except: %i[new request_code]

  def new
    clean_up_session
    @otp_form = Sessions::OTPSignInForm.new
  end

  def create
    render :new and return unless @otp_form.valid?

    if @otp_form.user.present?
      @otp_form.generate_and_email_code_to_user!

      session["otp_email"] = @otp_form.email
    end

    redirect_to otp_sign_in_code_path
  end

  def request_code
    @otp_form = Sessions::OTPSignInForm.new(email: session["otp_email"])
  end

  def verify_code
    if @otp_form.valid?(:verify)
      clean_up_session

      session_manager.begin_otp_session!(@otp_form.email)

      if authenticated?
        redirect_to(login_redirect_path)
      else
        session_manager.end_session!
        redirect_to(otp_sign_in_path)
      end
    else
      render :request_code
    end
  end

private

  def build_otp_form
    @otp_form = Sessions::OTPSignInForm.new(email:, code:)
  end

  def email
    permitted_params.fetch(:email, session["otp_email"])
  end

  def code
    permitted_params.fetch(:code, nil)
  end

  def clean_up_session
    session.delete("otp_email")
  end

  def permitted_params
    params.require(:sessions_otp_sign_in_form).permit(:email, :code)
  end
end
