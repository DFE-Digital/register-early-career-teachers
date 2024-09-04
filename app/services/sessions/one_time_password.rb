module Sessions
  class OneTimePassword
    attr_reader :user

    def initialize(user:)
      @user = user
    end

    def generate_and_send_code
      code = generate

      Rails.logger.debug("\n\e[33;1m===>>> OTP code for #{user.email} is: [\e[36m#{code}\e[33m] <<<===\e[0m\n")

      OTPMailer.with(recipient_email: user.email,
                     recipient_name: user.name,
                     code:).otp_code_email.deliver_later
    end

    def generate
      generate_otp_secret!
      totp.now
    end

    def verify(code:)
      # 600 = 10 mins validity
      # prevent re-use within window by using the last otp_verified_at
      params = {
        drift_behind: 600,
        after: user.otp_verified_at,
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
