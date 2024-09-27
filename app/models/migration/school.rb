module Migration
  class School < Migration::Base
    has_many :school_cohorts
    has_many :partnerships
  end
end
