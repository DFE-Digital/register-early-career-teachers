module PeriodBuilders
  class InductionPeriodBuilder
    attr_reader :appropriate_body, :school, :teacher

    def initialize(appropriate_body:, school:, teacher:)
      @appropriate_body = appropriate_body
      @school = school
      @teacher = teacher
    end

    def build(started_on:, finished_on: nil, induction_programme: :fip)
      ect_at_school_period = ECTAtSchoolPeriod.create!(teacher:, school:, started_on:, finished_on:)

      induction_period = create_induction_period(started_on:, finished_on:, induction_programme:, ect_at_school_period:)

      assign_induction_period_to_teacher(teacher, induction_period)

      induction_period
    end

  private

    def assign_induction_period_to_teacher(teacher, induction_period)
      teacher.induction_periods_reported_by_appropriate_body << induction_period
      teacher.save!
    end

    def create_induction_period(started_on:, finished_on:, induction_programme:, ect_at_school_period:)
      InductionPeriod.create!(
        appropriate_body:,
        ect_at_school_period:,
        started_on:,
        finished_on:,
        induction_programme:,
        number_of_terms: finished_on.present? ? [1, 2, 3].sample : nil
      )
    end
  end
end
