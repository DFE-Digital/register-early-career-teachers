class Teachers::TermsToBeCompleted
  attr_reader :teacher

  DEFAULT_NUMBER_OF_TERMS = 6

  def initialize(teacher)
    @teacher = teacher
  end

  def number_of_terms
    induction_period_number_of_terms + teacher.induction_extensions.sum(:extension_terms)
  end

private

  def induction_period_number_of_terms
    teacher.induction_periods_reported_by_appropriate_body.last&.number_of_terms || DEFAULT_NUMBER_OF_TERMS
  end
end
