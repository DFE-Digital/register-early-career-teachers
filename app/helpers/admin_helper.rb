module AdminHelper
  def admin_sub_navigation_structure
    @admin_sub_navigation_structure ||= Navigation::Structures::AdminSubNavigation.new.get
  end
end
