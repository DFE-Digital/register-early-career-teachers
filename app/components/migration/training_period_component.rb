module Migration
  class TrainingPeriodComponent < ViewComponent::Base
    attr_reader :training_period

    def initialize(training_period:)
      @training_period = training_period
    end

    def period_id
      training_period.id
    end

    def lead_provider_name
      training_period.provider_partnership.lead_provider.name
    end

    def delivery_partner_name
      training_period.provider_partnership.delivery_partner.name
    end

    def period_dates
      [training_period.started_on, training_period.finished_on || "ongoing"].join(" - ")
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
        started_on: training_period.legacy_start_id,
        provider: training_period.legacy_start_id,
      }
      if school_period.legacy_end_id.present?
        attrs[:finished_on] = training_period.legacy_end_id
      end

      attrs
    end
  end
end
