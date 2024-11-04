module Migration
  class AppropriateBody < Migration::Base
    has_many :induction_records
    has_many :school_cohorts
  end
end
