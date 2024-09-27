module Migration
  class InductionRecord < Migration::Base
    belongs_to :participant_profile
    belongs_to :induction_programme
  end
end
