module Migration
  class InductionProgramme < Migration::Base
    belongs_to :school_cohort
    belongs_to :partnership, optional: true
    belongs_to :core_induction_programme, optional: true
    has_many :induction_records
  end
end
