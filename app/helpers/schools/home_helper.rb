module Schools::HomeHelper
  def displayed_mentor_for_ect(school, mentor_name, ect_trn, ect_name)
    return mentor_name if mentor_name.present?

    govuk_warning_text(text: "You must #{assign_or_create_mentor_link(school, ect_trn, ect_name)} for this ECT.".html_safe)
  end

private

  def assign_or_create_mentor_link(school, ect_trn, ect_name)
    govuk_link_to("assign a mentor or register a new one",
                  assign_or_create_mentor_path(school, ect_trn, ect_name),
                  no_visited_state: true)
  end

  def assign_or_create_mentor_path(school, ect_trn, ect_name)
    if school.current_mentor_teachers.exists?
      who_will_be_mentoring_schools_ect_path(trn: ect_trn)
    else
      schools_register_mentor_start_path(ect_name: ect_name)
    end
  end
end
