class OTPMailerPreview < ActionMailer::Preview
  def otp_code_email
    OTPMailer.with(recipient_email: "velma@example.com", recipient_name: "Velma Dinkley", code: "123456").otp_code_email
  end
end
