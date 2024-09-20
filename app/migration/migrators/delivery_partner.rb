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
      if Rails.env.development?
        ::DeliveryPartner.connection.execute("TRUNCATE #{::DeliveryPartner.table_name} RESTART IDENTITY CASCADE")
      end
    end

    def migrate!
      Rails.logger.info("Migrating #{self.class.record_count} delivery partners")

      migrate(self.class.delivery_partners) do |delivery_partner|
        Rails.logger.info("  --> #{delivery_partner.name}")
        ::DeliveryPartner.create!(name: delivery_partner.name)
      end
    end
  end
end
