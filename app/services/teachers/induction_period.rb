class Teachers::InductionPeriod
  attr_reader :teacher

  def initialize(teacher)
    @teacher = teacher
  end

  def induction_start_date
    first_induction_period&.started_on
  end

private

  def first_induction_period
    @first_induction_period ||= teacher.induction_periods_reported_by_appropriate_body.first
  end
end
