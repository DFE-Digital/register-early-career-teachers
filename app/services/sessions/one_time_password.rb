module Sessions
  class OneTimePassword
    attr_reader :user

    def initialize(user:)
      @user = user
    end

    def generate_and_send_code
      code = generate

      Rails.logger.debug(Colourize.text("\n===>>> OTP code for #{user.email} is: [#{code}] <<<===\n", :yellow))

      OTPMailer.with(recipient_email: user.email,
                     recipient_name: user.name,
                     code:).otp_code_email.deliver_later
    end

    def generate
      generate_otp_secret!
      totp.now
    end

    def verify(code:)
      params = {
        drift_behind: 10.minutes.in_seconds, # give a 10 minute window to use the OTP code
        after: user.otp_verified_at,         # prevents re-use of OTP code within the window
      }.compact

      tm = totp.verify(code, **params)

      return false if tm.blank?

      user.update!(otp_verified_at: Time.zone.at(tm))
    end

  private

    def totp
      ROTP::TOTP.new(user.otp_secret, issuer: "ECF2")
    end

    def generate_otp_secret!
      user.update!(otp_secret: ROTP::Base32.random(16))
    end
  end
end
