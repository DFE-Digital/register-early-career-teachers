# this handles a Persona user session within omniauth authentication
# primarily lifted/inspired by [Register trainee teachers](https://github.com/DFE-Digital/register-trainee-teachers)
class UserSession
  attr_reader :email, :provider

  def initialize(email:, provider: "developer")
    @email = email
    @provider = provider
  end

  def self.begin_session!(session, email, provider)
    session["user_session"] = {
      "provider" => provider,
      "email" => email,
      "last_active_at" => Time.zone.now,
    }
  end

  def self.load_from_session(session)
    user_session = session["user_session"]
    return unless user_session

    return if user_session["last_active_at"] < 2.hours.ago

    user_session["last_active_at"] = Time.zone.now
    new(email: user_session["email"],
        provider: user_session["provider"])
  end

  def self.end_session!(session)
    session.destroy # rubocop:disable Rails/SaveBang
  end

  def user
    @user ||= User.find_by(email:)
  end
end
