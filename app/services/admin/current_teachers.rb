module Admin
  class CurrentTeachers
    attr_reader :appropriate_body_ids

    def initialize(appropriate_body_ids)
      @appropriate_body_ids = Array(appropriate_body_ids)
    end

    def current
      scope = Teacher.joins(:induction_periods).merge(InductionPeriod.ongoing)

      if appropriate_body_ids.any?
        scope = scope.merge(InductionPeriod.for_appropriate_body(appropriate_body_ids))
      end

      scope.distinct
    end
  end
end
