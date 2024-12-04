module Sessions
  class SessionManager
    MAX_SESSION_IDLE_TIME = 2.hours

    attr_reader :session

    def initialize(session)
      @session = session
    end

    def begin_developer_session!(email)
      session["user_session"] = {
        "provider" => "otp",
        "email" => email,
        **session_defaults
      }
    end

    def begin_dfe_sign_in_session!(user_info)
      Rails.logger.debug("initializing dfe sign-in session")
      Rails.logger.debug("  urn: #{user_info.extra.raw_info.organisation.urn}")
      Rails.logger.debug("  provider: #{user_info.provider}")

      session['user_session'] = {
        'email' => user_info.info.email,
        'name' => user_info.info.then { |info| "#{info.first_name} #{info.last_name}" },
        'organisation_id' => user_info.extra.raw_info.organisation.id,
        'provider' => user_info.provider,
        'urn' => user_info.extra.raw_info.organisation.urn,
        **session_defaults
      }
    end

    def session_defaults
      { 'last_active_at' => Time.zone.now }
    end

    def load_from_session
      return if current_session.blank?

      return if expired?

      user = User.find_by!(email:)

      current_session["last_active_at"] = Time.zone.now

      user
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error("Email was not found: #{email}")
      nil
    end

    def end_session!
      session.destroy
    end

    def requested_path=(path)
      session[:requested_path] = path
    end

    def requested_path
      session.delete(:requested_path)
    end

    def expired?
      return true unless last_active_at

      last_active_at < MAX_SESSION_IDLE_TIME.ago
    end

    def expires_at
      (last_active_at + MAX_SESSION_IDLE_TIME) if last_active_at
    end

    def provider
      current_session&.fetch("provider", nil)
    end

    def appropriate_body_id=(id)
      Rails.logger.info("Setting session appropriate_body_id to #{id}")

      session["appropriate_body_id"] = id
    end

    def school_urn=(urn)
      Rails.logger.info("Setting session school_urn to #{urn}")

      session["school_urn"] = urn
    end

  private

    def current_session
      @current_session ||= session["user_session"]
    end

    def last_active_at
      current_session&.fetch("last_active_at", nil)
    end

    def email
      current_session&.fetch("email", nil)
    end
  end
end
