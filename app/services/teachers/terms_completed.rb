class Teachers::TermsCompleted
  attr_reader :teacher

  DEFAULT_NUMBER_OF_TERMS = 6

  def initialize(teacher)
    @teacher = teacher
  end

  def formatted_terms_completed
    "#{terms_completed} of #{total_terms_required}"
  end

private

  def terms_completed
    teacher.induction_periods.sum(:number_of_terms)
  end

  def total_terms_required
    DEFAULT_NUMBER_OF_TERMS + teacher.induction_extensions.sum(:number_of_terms)
  end
end
