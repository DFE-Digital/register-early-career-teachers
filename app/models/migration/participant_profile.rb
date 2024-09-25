module Migration
  class ParticipantProfile < Migration::Base
    self.inheritance_column = nil

    belongs_to :teacher_profile
    has_many :induction_records

    scope :ect, -> { where(type: "ParticipantProfile::ECT") }
    scope :mentor, -> { where(type: "ParticipantProfile::Mentor") }
  end
end
