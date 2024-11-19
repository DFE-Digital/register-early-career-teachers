module Admin
  class Access
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def can_access?
      user&.dfe?
    end
  end
end
