module Migrators
  class LeadProvider < Migrators::Base
    def self.record_count
      lead_providers.count
    end

    def self.model
      :lead_provider
    end

    def self.lead_providers
      ::Migration::LeadProvider.all
    end

    def self.reset!
      if Rails.application.config.enable_migration_testing
        ::LeadProvider.connection.execute("TRUNCATE #{::LeadProvider.table_name} RESTART IDENTITY CASCADE")
      end
    end

    def migrate!
      migrate(self.class.lead_providers) do |lead_provider|
        ::LeadProvider.create!(name: lead_provider.name)
      end
    end
  end
end
