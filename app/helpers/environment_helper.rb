module EnvironmentHelper
  def environment_specific_header_colour_class
    return if ENVIRONMENT_COLOUR.blank?

    "app-header--#{ENVIRONMENT_COLOUR}"
  end

  def environment_specific_phase_banner
    tag_text = ENVIRONMENT_PHASE_BANNER_TAG || "Beta"
    banner_text = ENVIRONMENT_PHASE_BANNER_CONTENT || govuk_link_to("Give feedback about this service", "#")

    govuk_phase_banner(text: banner_text, tag: { text: tag_text, colour: ENVIRONMENT_COLOUR }.compact)
  end
end
