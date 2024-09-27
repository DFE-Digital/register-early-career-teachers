module Migration
  class User < Migration::Base
    has_one :teacher_profile
  end
end
