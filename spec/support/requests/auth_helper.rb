module AuthHelper
  def sign_in_as(user_type, method: :persona, appropriate_body: nil)
    Rails.logger.info("logging in as #{user_type}")

    case method
    when :otp then sign_in_with_otp(user_type)
    when :persona then sign_in_with_persona(user_type, appropriate_body:)
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

  def sign_in_with_persona(user_type, appropriate_body:)
    fake_name = Faker::Name.name
    fake_email = Faker::Internet.email

    case user_type
    when :appropriate_body_user
      fail(ArgumentError, "appropriate_body missing") unless appropriate_body

      Rails.logger.debug("Signing in with persona as appropriate body user")
      post("/auth/developer/callback", params: { email: fake_email, name: fake_name, appropriate_body_id: appropriate_body.id })
    end
  end
end

RSpec.configure { |config| config.include(AuthHelper, type: :request) }
