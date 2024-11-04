module Migration
  class ParticipantProfile < Migration::Base
    self.inheritance_column = nil

    belongs_to :teacher_profile
    has_many :induction_records
    has_many :school_mentors # only ParticipantProfile::Mentor

    scope :ect, -> { where(type: "ParticipantProfile::ECT") }
    scope :mentor, -> { where(type: "ParticipantProfile::Mentor") }
    scope :ect_or_mentor, -> { ect.or(mentor) }

    def ect?
      type == "ParticipantProfile::ECT"
    end

    def mentor?
      type == "ParticipantProfile::Mentor"
    end
  end
end
