module Sessions
  class SessionUser
    attr_reader :provider, :name, :email, :appropriate_body_id, :school_urn, :dfe

    def initialize(provider:, email:, name: nil, appropriate_body_id: nil, school_urn: nil, dfe_sign_in_organisation_id: nil, dfe: false, last_active_at: Time.zone.now)
      @provider = provider
      @name = name
      @email = email
      @last_active_at = last_active_at
      @appropriate_body_id = appropriate_body_id
      @school_urn = school_urn
      @dfe = dfe
      @dfe_sign_in_organisation_id = dfe_sign_in_organisation_id
    end

    def last_active_at
      # FIXME: why is this sometimes a string?
      @last_active_at.is_a?(String) ? Time.zone.parse(@last_active_at) : @last_active_at
    end

    def record_new_activity!(session:, time: Time.zone.now)
      session['user_session']['last_active_at'] = time

      self
    end

    def dfe_user?
      dfe
    end

    def appropriate_body_user?
      appropriate_body_id.present?
    end

    def school_user?
      school_urn.present?
    end

    def self.from_session(user_session)
      new(
        provider: user_session['provider'],
        name: user_session['name'],
        email: user_session['email'],
        appropriate_body_id: user_session['appropriate_body_id'],
        last_active_at: user_session['last_active_at'],
        school_urn: user_session['school_urn'],
        dfe: user_session['dfe']
      )
    end

    def self.from_dfe_sign_in(user_info)
      new(
        provider: user_info.provider,
        name: user_info.info.then { |info| "#{info.first_name} #{info.last_name}" },
        school_urn: user_info.extra.raw_info.organisation.urn,
        dfe_sign_in_organisation_id: user_info.extra.raw_info.organisation.id,
        email: user_info.info.email
      )
    end

    def self.from_user_record(email:, provider:)
      user = User.find_by!(email:)

      new(
        provider:,
        name: user.name,
        email: email,
        dfe: true
      )
    end

    def to_h
      {
        "provider" => provider,
        "email" => email,
        "name" => name,
        "last_active_at" => last_active_at,
        "appropriate_body_id" => appropriate_body_id.presence,
        "school_urn" => school_urn.presence,
        "dfe" => dfe,
      }
    end
  end
end
