class Teachers::HasInductionExtensions
  attr_reader :teacher

  def initialize(teacher)
    @teacher = teacher
  end

  def yes_or_no
    teacher.induction_extensions.any? ? "Yes" : "No"
  end
end
