module Sessions
  class User
    attr_reader :name, :email

    def initialize(name, email)
      @name = name
      @email = email
    end

    def self.from_dfe_signin(user_info)
      name = 'omg'
      email = 'wtf'
      new(name, email)
    end

    def self.from_user_record(user)
    end

    def expired?
    end

    def last_active_at
    end

    def to_h
    end

    def dfe?
      false
    end

    def appropriate_body?
    end
  end
end
