module Migrators
  class ProviderPartnership < Migrators::Base
    def self.record_count
      provider_relationships.count
    end

    def self.model
      :provider_partnership
    end

    def self.provider_relationships
      ::Migration::ProviderRelationship.all
    end

    def self.dependencies
      %i[academic_year lead_provider delivery_partner]
    end

    def self.reset!
      if Rails.application.config.enable_migration_testing
        ::ProviderPartnership.connection.execute("TRUNCATE #{::ProviderPartnership.table_name} RESTART IDENTITY CASCADE")
      end
    end

    def migrate!
      migrate(self.class.provider_relationships.includes(:lead_provider, :delivery_partner, :cohort)) do |provider_relationship|
        ::ProviderPartnership.create!(lead_provider: ::LeadProvider.find_by!(name: provider_relationship.lead_provider.name),
                                      delivery_partner: ::DeliveryPartner.find_by!(name: provider_relationship.delivery_partner.name),
                                      academic_year: ::AcademicYear.find(provider_relationship.cohort.start_year))
      end
    end
  end
end
