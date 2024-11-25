module AppropriateBodies
  class CurrentTeachers
    attr_reader :appropriate_body

    def initialize(appropriate_body)
      @appropriate_body = appropriate_body
    end

    def current
      Teacher
        .joins(:induction_periods)
        .merge(InductionPeriod.for_appropriate_body(appropriate_body))
        .merge(InductionPeriod.ongoing)
    end
  end
end
