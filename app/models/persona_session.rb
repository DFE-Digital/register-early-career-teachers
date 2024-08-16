# this handles a Persona user session within omniauth authentication
# primarily lifted/inspired by [Register trainee teachers](https://github.com/DFE-Digital/register-trainee-teachers)
class PersonaSession
  attr_reader :email, :name

  def initialize(email:, name:, provider: "developer")
    @email = email
    @name = name
    @provider = provider
  end

  def self.begin_session!(session, omniauth_payload)
    session["persona_session"] = {
      "provider" => omniauth_payload.provider,
      "email" => omniauth_payload.uid,
      "name" => omniauth_payload.info.name,
      "last_active_at" => Time.zone.now,
    }
  end

  def self.load_from_session(session)
    persona_session = session["persona_session"]
    return unless persona_session

    return if persona_session["last_active_at"] < 2.hours.ago

    persona_session["last_active_at"] = Time.zone.now
    new(email: persona_session["email"],
        name: persona_session["name"],
        provider: persona_session["provider"])
  end

  def self.end_session!(session)
    session.destroy # rubocop:disable Rails/SaveBang
  end

  def user
    @user ||= User.find_by(email:)
  end
end
