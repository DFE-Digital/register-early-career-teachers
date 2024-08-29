class OTPSessionsController < ApplicationController
  skip_before_action :authenticate
  before_action :build_otp_form, except: %i[new request_code]

  def new
    clean_up_session
    @otp_form = OTPSignInForm.new
  end

  def create
    if @otp_form.valid?
      if @otp_form.user.present?
        @otp_form.generate_and_email_code_to_user!

        session["otp_email"] = @otp_form.email
      end

      # this should probably always redirect here regardless of whether
      # the email is in our service or not so that we're not leaking info
      redirect_to otp_sign_in_code_path
    else
      render :new
    end
  end

  def request_code
    @otp_form = OTPSignInForm.new(email: session["otp_email"])
  end

  def verify_code
    if @otp_form.valid?(:verify)
      clean_up_session

      # begin authenticated session
      UserSession.begin_session!(session, @otp_form.email, "otp")

      if authenticated?
        redirect_to(login_redirect_path)
      else
        session.delete(:requested_path)
        UserSession.end_session!(session)
        redirect_to(otp_sign_in_path)
      end
    else
      render :request_code
    end
  end

private

  def build_otp_form
    @otp_form = OTPSignInForm.new(email:, code:)
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

  def login_redirect_path
    # this should return the "home" location for the signed in user first perhaps?
    session.delete(:requested_path) || root_path
  end

  def permitted_params
    params.require(:otp_sign_in_form).permit(:email, :code)
  end
end
