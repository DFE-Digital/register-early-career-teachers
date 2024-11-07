module School::RegisterECTHelper
  def link_to_ect(name)
    govuk_link_to(name,
                  '#',
                  no_visited_state: true)
  end

  def in_progress_status
    govuk_tag(text: 'In progress', colour: 'green')
  end
end
