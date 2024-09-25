module Migration
  class TeacherProfile < Migration::Base
    belongs_to :user
    belongs_to :participant_profile
  end
end
