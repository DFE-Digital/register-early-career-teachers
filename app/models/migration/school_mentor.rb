module Migration
  class SchoolMentor < Migration::Base
    belongs_to :participant_profile
    belongs_to :school
  end
end
