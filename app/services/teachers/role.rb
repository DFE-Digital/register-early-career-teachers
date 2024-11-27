class Teachers::Role
  attr_reader :teacher

  def initialize(teacher:)
    @teacher = teacher
  end

  def to_s
    roles.join(" & ")
  end

  def roles
    @roles ||= determine_roles
  end

private

  def determine_roles
    result = []

    if teacher.ect_at_school_periods.ongoing.any?
      result << "ECT"
    elsif teacher.ect_at_school_periods.any?
      result << "ECT (Inactive)"
    end

    if teacher.mentor_at_school_periods.ongoing.any?
      result << "Mentor"
    elsif teacher.mentor_at_school_periods.any?
      result << "Mentor (Inactive)"
    end

    result
  end
end
