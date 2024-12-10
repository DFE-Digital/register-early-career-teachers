module AdminHelper
  def admin_sub_navigation_structure
    @admin_sub_navigation_structure ||= Navigation::Structures::AdminSubNavigation.new.get
  end

  def admin_teacher_name_link(teacher)
    govuk_link_to(Teachers::Name.new(teacher).full_name, admin_teacher_path(teacher))
  end

  def admin_teachers_list_links(teachers)
    govuk_list(teachers.map { |teacher| admin_teacher_name_link(teacher) })
  end
end
