module Admin
  class TrainingPeriodPresenter < SimpleDelegator
    def self.wrap(collection)
      collection.map { |item| new(item) }
    end

    def lead_provider
      @lead_provider ||= training_period.provider_partnership.lead_provider
    end

    def delivery_partner
      @delivery_partner ||= training_period.provider_partnership.delivery_partner
    end

    def formatted_started_on
      training_period.started_on.to_fs(:govuk)
    end

    def formatted_finished_on
      return "" if training_period.finished_on.blank?

      training_period.finished_on.to_fs(:govuk)
    end

  private

    def training_period
      __getobj__
    end
  end
end
