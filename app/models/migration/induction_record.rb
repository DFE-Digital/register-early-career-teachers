module Migration
  class InductionRecord < Migration::Base
    belongs_to :participant_profile
    belongs_to :induction_programme
    belongs_to :appropriate_body
    belongs_to :mentor_profile, class_name: "Migration::ParticipantProfile"
  end
end
