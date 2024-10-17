class Teachers::Name
  attr_reader :teacher

  def initialize(teacher)
    @teacher = teacher
  end

  def full_name
    return if teacher.blank?

    teacher.corrected_name || first_name_plus_last_name
  end

private

  # this isn't really the _right_ thing to do but given
  # we only receive separate first and last names from TRS
  # we're left with little option
  def first_name_plus_last_name
    %(#{teacher.first_name} #{teacher.last_name})
  end
end
