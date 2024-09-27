module Migration
  class InductionProgramme < Migration::Base
    belongs_to :school_cohort
    belongs_to :partnership, optional: true
    has_many :induction_records
  end
end
