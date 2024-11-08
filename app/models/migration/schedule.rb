module Migration
  class Schedule < Migration::Base
    self.inheritance_column = nil

    belongs_to :cohort
  end
end
