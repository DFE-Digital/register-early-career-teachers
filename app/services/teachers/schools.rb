module Teachers
  class Schools
    attr_reader :teacher

    def initialize(teacher)
      @teacher = teacher
    end

    def ECT_training_at
      teacher.ect_at_school_period.ongoing.first
    end

    def mentoring_at
      teacher.mentor_at_school_period.ongoing
    end
  end
end
