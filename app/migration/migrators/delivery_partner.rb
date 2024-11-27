module Migrators
  class DeliveryPartner < Migrators::Base
    def self.record_count
      delivery_partners.count
    end

    def self.model
      :delivery_partner
    end

    def self.delivery_partners
      ::Migration::DeliveryPartner.all
    end

    def self.reset!
      if Rails.application.config.enable_migration_testing
        ::DeliveryPartner.connection.execute("TRUNCATE #{::DeliveryPartner.table_name} RESTART IDENTITY CASCADE")
      end
    end

    def migrate!
      migrate(self.class.delivery_partners) do |delivery_partner|
        ::DeliveryPartner.create!(name: delivery_partner.name)
      end
    end
  end
end
