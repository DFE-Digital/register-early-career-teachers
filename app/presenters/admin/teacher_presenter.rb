module Admin
  class TeacherPresenter < SimpleDelegator
    def self.wrap(collection)
      collection.map { |teacher| new(teacher) }
    end

    def full_name
      Teachers::Name.new(teacher).full_name
    end

    def roles
      Teachers::Role.new(teacher:).to_s
    end

    def ect?
      teacher.ect_at_school_periods.any?
    end

    def mentor?
      teacher.mentor_at_school_periods.any?
    end

    def latest_school_period_as_an_ect
      latest = school_periods_as_an_ect.first
      SchoolPeriodPresenter.new(latest) if latest.present?
    end

    def school_periods_as_an_ect
      teacher.ect_at_school_periods.order(started_on: :desc)
    end

    def latest_school_period_as_a_mentor
      latest = school_periods_as_a_mentor.first
      SchoolPeriodPresenter.new(latest) if latest.present?
    end

    def school_periods_as_a_mentor
      teacher.mentor_at_school_periods.order(started_on: :desc)
    end

    def migration_failures
      MigrationFailure.where(parent_id: teacher.id, parent_type: "Teacher").order(:id)
    end

  private

    def teacher
      __getobj__
    end
  end
end
