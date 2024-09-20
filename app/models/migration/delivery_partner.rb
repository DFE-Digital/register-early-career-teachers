module Migration
  class DeliveryPartner < Migration::Base
    self.table_name = 'delivery_partners'
    default_scope { where(discarded_at: nil) }
  end
end
