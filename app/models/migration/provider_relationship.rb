module Migration
  class ProviderRelationship < Migration::Base
    self.table_name = 'provider_relationships'
    default_scope { where(discarded_at: nil) }

    belongs_to :lead_provider
    belongs_to :delivery_partner
    belongs_to :cohort
  end
end
