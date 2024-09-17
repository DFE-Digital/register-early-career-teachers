module AuthHelper
  def sign_in_as(user_type, method: :otp)
    Rails.logger.info("logging in as #{user_type}")

    case method
    when :otp then sign_in_with_otp(user_type)
    end
  end

private

  def sign_in_with_otp(_user_type)
    # TODO: once we have user types make sure this signs us in with the correct
    #       kind of user
    user = FactoryBot.create(:user)
    post(otp_sign_in_path, params: { sessions_otp_sign_in_form: { email: user.email } })
    post(
      otp_sign_in_verify_path,
      params: {
        sessions_otp_sign_in_form: { code: Sessions::OneTimePassword.new(user:).generate },
      }
    )
  end
end
