module Migration
  class DeliveryPartner < Migration::Base
    default_scope { where(discarded_at: nil) }

    has_many :partnerships
  end
end
