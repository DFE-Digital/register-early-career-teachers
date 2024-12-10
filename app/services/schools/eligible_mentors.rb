module Schools
  class EligibleMentors
    def initialize(school)
      @school = school
    end

    def for_ect(ect)
      @school.current_mentors.excluding(ect_as_mentor_at_school(ect))
    end

  private

    def ect_as_mentor_at_school(ect)
      ect.mentor_at_school_periods.for_school(@school).ongoing
    end
  end
end
