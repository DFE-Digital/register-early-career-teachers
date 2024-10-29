module Migration
  class SchoolPeriodPresenter < SimpleDelegator
    def self.wrap(school_periods)
      school_periods.map { |school_period| new(school_period) }
    end

    def school_name_and_urn
      "#{gias_school.name} (#{gias_school.urn})"
    end

  private

    def school_period
      __getobj__
    end

    def gias_school
      @gias_school ||= school_period.school.gias_school
    end
  end
end
