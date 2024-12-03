module Migration
  class MentorshipPeriodComponent < ViewComponent::Base
    attr_reader :mentorship_period

    def initialize(mentorship_period:)
      @mentorship_period = mentorship_period
    end

    def period_id
      mentorship_period.id
    end

    def mentor_name
      @mentor_name ||= Teachers::Name.new(mentorship_period.mentor.teacher).full_name
    end

    def period_dates
      [mentorship_period.started_on, mentorship_period.finished_on || "ongoing"].join(" - ")
    end

    def attributes_for(attr)
      attrs = {}
      if matched_attrs.key?(attr)
        attrs[:classes] = "matched"
      end
      attrs
    end

    def matched_attrs
      @matched_attrs ||= build_matched_attrs
    end

    def build_matched_attrs
      attrs = {
        started_on: mentorship_period.legacy_start_id,
        mentor: mentorship_period.legacy_start_id,
      }
      if mentorship_period.legacy_end_id.present?
        attrs[:finished_on] = mentorship_period.legacy_end_id
      end

      attrs
    end
  end
end
