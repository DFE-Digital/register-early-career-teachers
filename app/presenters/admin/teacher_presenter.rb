module Admin
  class TeacherPresenter < SimpleDelegator
    def full_name
      Teachers::Name.new(teacher).full_name
    end

    def ect?
      teacher.ect_at_school_periods.any?
    end

    def mentor?
      teacher.mentor_at_school_periods.any?
    end

  private

    def teacher
      __getobj__
    end

  end
end
