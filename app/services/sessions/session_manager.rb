module Sessions
  class SessionManager
    attr_reader :session

    def initialize(session)
      @session = session
    end

    def begin_session!(email, provider)
      session["user_session"] = {
        "provider" => provider,
        "email" => email,
        "last_active_at" => Time.zone.now,
      }
    end

    def load_from_session
      return unless (user_session = session["user_session"])

      return if user_session["last_active_at"] < 2.hours.ago

      user = User.find_by!(email: user_session["email"])

      user_session["last_active_at"] = Time.zone.now

      user
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error("Email was not found: #{user_session['email']}")
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
  end
end
