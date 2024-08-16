# This handles the session for a one time password user
# it follows the omniauth persona style but is not handled by
# omniauth
class OTPSession
  attr_reader :email

  def initialize(email:, provider: "otp")
    @email = email
    @provider = provider
  end

  def self.begin_session!(session, email)
    session["otp_session"] = {
      "provider" => "otp",
      "email" => email,
      "last_active_at" => Time.zone.now,
    }
  end

  def self.load_from_session(session)
    otp_session = session["otp_session"]
    return unless otp_session

    return if otp_session["last_active_at"] < 2.hours.ago

    otp_session["last_active_at"] = Time.zone.now
    new(email: otp_session["email"],
        provider: otp_session["provider"])
  end

  def self.end_session!(session)
    session.destroy # rubocop:disable Rails/SaveBang
  end

  def user
    @user ||= User.find_by(email:)
  end
end
