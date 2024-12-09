module Schools::HomeHelper
  def link_to_assign_mentor(ect)
    govuk_warning_text(text: "You must #{assign_or_create_mentor_link(ect)} for this ECT.".html_safe)
  end

private

  def assign_or_create_mentor_link(ect)
    govuk_link_to("assign a mentor or register a new one", assign_or_create_mentor_path(ect), no_visited_state: true)
  end

  def assign_or_create_mentor_path(ect)
    return new_schools_ect_mentorship_path(ect) if eligible_mentors_for_ect?(ect)

    schools_register_mentor_wizard_start_path(ect_id: ect.id)
  end

  def eligible_mentors_for_ect?(ect)
    Schools::EligibleMentors.new(ect.school).for_ect(ect).exists?
  end
end
