module Sessions
  class SessionManager
    MAX_SESSION_IDLE_TIME = 2.hours

    attr_reader :session

    def initialize(session)
      @session = session
    end

    def begin_session!(user_info)
      provider = user_info.fetch('provider')

      session["user_session"] = build_session_data(user_info, provider.to_s)
    end

    def load_from_session
      return if current_session.blank?

      return if expired?

      user = case session["user_session"]["provider"]
             when "developer"
               User.find_by!(email:)
             when "dfe"
               session['user_session']
             end

      current_session["last_active_at"] = Time.zone.now

      Sessions::User.new(user)
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

    def build_session_data(user_info, provider)
      case provider
      when 'dfe'
        name = "#{user_info.dig('info', 'first_name')} #{user_info.dig('info', 'last_name')}"

        {
          "email" => user_info.dig('info', 'email'),
          "name" => name,
          "organisation_id" => user_info.dig('extra', 'raw_info', 'organisation', 'id'),
          "urn" => user_info.dig('extra', 'raw_info', 'organisation', 'urn'),
          "last_active_at" => Time.zone.now,
          "provider" => provider
        }

      when 'developer'
        {
          "email" => user_info.uid,
          "last_active_at" => Time.zone.now,
          "provider" => provider,
        }
      end
    end
  end
end
