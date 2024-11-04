module TeachersHelper
  def full_name_of(teacher)
    [teacher.first_name, teacher.last_name].join(" ")
  end
end
