module Migrators
  class LeadProvider
    attr_reader :logger

    def initialize(logger = Rails.logger)
      @logger = logger
    end

    def migrate
      Migration::LeadProvider.all.tap do |lead_providers|
        logger.info("Importing #{lead_providers.size} lead providers")

        lead_providers.each { |lp| import(lp) }
      end
    end

  private

    def import(lead_provider)
      logger.info("  #{lead_provider.name}")

      ::LeadProvider.create!(name: lead_provider.name)
    end
  end
end
