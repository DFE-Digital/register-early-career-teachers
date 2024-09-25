module Migration
  class TeacherProfile < Migration::Base
    belongs_to :user
    has_many :participant_profiles
  end
end
