module AuthHelper
  def sign_in_as(user_type, method: :persona)
    Rails.logger.info("logging in as #{user_type}")

    case method
    when :otp then sign_in_with_otp(user_type)
    when :persona then sign_in_with_persona(user_type)
    end
  end

private

  def sign_in_with_otp(user_type)
    FactoryBot.create(:user, user_type).tap do |user|
      post(otp_sign_in_path, params: { sessions_otp_sign_in_form: { email: user.email } })
      post(
        otp_sign_in_verify_path,
        params: {
          sessions_otp_sign_in_form: { code: Sessions::OneTimePassword.new(user:).generate },
        }
      )
    end
  end

  def sign_in_with_persona(user_type)
    FactoryBot.create(:user, user_type).tap do |user|
      case user_type
      when :appropriate_body_user
        Rails.logger.debug("Signing in with persona as appropriate body user")
        post("/auth/developer/callback", params: { email: user.email, name: user.name })
        appropriate_body = FactoryBot.create(:appropriate_body)
        put("/personas/appropriate-body-sessions", params: { appropriate_body_id: appropriate_body.id })
      end
    end
  end
end

RSpec.configure { |config| config.include(AuthHelper, type: :request) }
