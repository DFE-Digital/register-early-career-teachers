class Teachers::ActiveInductionPeriod
  attr_reader :teacher

  def initialize(teacher)
    @teacher = teacher
  end

  def active_induction_period
    # should this be just Teachers::InductionPeriod?
    teacher.induction_periods_reported_by_appropriate_body.find_by(finished_on: nil)
  end
end
