module Migration
  class SchoolCohort < Migration::Base
    belongs_to :school
    belongs_to :cohort
    has_many :induction_programmes
  end
end
