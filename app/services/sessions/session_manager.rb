module Sessions
  class SessionManager
    MAX_SESSION_IDLE_TIME = 2.hours

    attr_reader :session

    delegate :provider, to: :current_user

    def initialize(session)
      @session = session
    end

    def begin_otp_session!(email)
      session['user_session'] = SessionUser.from_user_record(email:, provider: 'otp').to_h
    end

    def begin_persona_session!(email, name: nil, appropriate_body_id: nil, school_urn: nil)
      session['user_session'] = SessionUser.new(provider: 'developer', email:, name:, appropriate_body_id:, school_urn:).to_h
    end

    def begin_dfe_sign_in_session!(user_info)
      session['user_session'] = {
        'email' => user_info.info.email,
        'name' => user_info.info.then { |info| "#{info.first_name} #{info.last_name}" },
        'organisation_id' => user_info.extra.raw_info.organisation.id,
        'provider' => user_info.provider,
        'urn' => user_info.extra.raw_info.organisation.urn,
        'last_active_at' => Time.zone.now
      }
    end

    def load_from_session
      return if current_user.blank?

      return if expired?

      current_user.record_new_activity!(session:)
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

  private

    def current_user
      return if session['user_session'].blank?

      @current_user ||= Sessions::SessionUser.from_session(session['user_session'])
    end

    def current_session
      @current_session ||= session["user_session"]
    end

    def last_active_at
      return if current_user.blank?

      current_user.last_active_at
    end

    def email
      return if current_user.blank?

      current_user.email
    end
  end
end
