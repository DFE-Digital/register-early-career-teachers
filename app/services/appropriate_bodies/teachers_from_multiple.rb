module AppropriateBodies
  class TeachersFromMultiple
    attr_reader :appropriate_body_ids

    def initialize(appropriate_body_ids)
      @appropriate_body_ids = Array(appropriate_body_ids)
    end

    def teachers
      return Teacher.none if appropriate_body_ids.empty?

      Teacher
        .joins(:induction_periods)
        .merge(InductionPeriod.for_appropriate_body(appropriate_body_ids))
        .merge(InductionPeriod.ongoing)
        .distinct
    end
  end
end
