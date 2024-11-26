class Teachers::InductionExtensions
  attr_reader :teacher

  def initialize(teacher)
    @teacher = teacher
  end

  def yes_or_no
    teacher.induction_extensions.any? ? "Yes" : "No"
  end

  def formatted_number_of_terms
    "#{number_of_terms} terms"
  end

private

  def number_of_terms
    teacher.induction_extensions.sum(&:number_of_terms)
  end
end
