class OTPMailer < ApplicationMailer
  def otp_code_email
    to = params.fetch(:recipient_email)
    @recipient_name = params.fetch(:recipient_name)
    @code = params.fetch(:code)

    view_mail(NOTIFY_TEMPLATE_ID, to:, subject: "Sign-in to ECF2 with this one time password")
  end
end
