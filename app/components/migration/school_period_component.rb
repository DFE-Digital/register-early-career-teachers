module Migration
  class SchoolPeriodComponent < ViewComponent::Base
    attr_reader :school_period

    def initialize(school_period:)
      @school_period = school_period
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
        started_on: school_period.legacy_start_id,
        school: school_period.legacy_start_id,
      }
      if school_period.legacy_end_id.present?
        attrs[:finished_on] = school_period.legacy_end_id
      end

      attrs
    end
  end
end
