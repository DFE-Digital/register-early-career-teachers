module Schools
  class Teachers
    def initialize(school)
      @school = school
    end

    def all_ects
      @all_ects ||= latest_period_of_all_ects.map(&:teacher)
    end

    def all_mentors
      @all_mentors ||= latest_period_of_all_mentors.map(&:teacher)
    end

    def current_ects
      @current_ects ||= current_ect_periods.map(&:teacher)
    end

    def current_ect_periods
      @current_ect_periods ||= @school
                                 .ect_at_school_periods
                                 .includes(:teacher)
                                 .ongoing
    end

    def current_mentors
      @current_mentors ||= current_mentor_periods.map(&:teacher)
    end

    def current_mentor_periods
      @current_mentor_periods ||= @school
                                    .mentor_at_school_periods
                                    .includes(:teacher)
                                    .ongoing
    end

    def latest_period_of_all_ects
      @latest_period_of_all_ects ||= @school
                                       .ect_at_school_periods
                                       .includes(:teacher)
                                       .order("teacher_id, started_on DESC")
                                       .select("DISTINCT ON (teacher_id) *")
    end

    def latest_period_of_all_mentors
      @latest_period_of_all_mentors ||= @school
                                       .mentor_at_school_periods
                                       .includes(:teacher)
                                       .order("teacher_id, started_on DESC")
                                       .select("DISTINCT ON (teacher_id) *")
    end
  end
end
