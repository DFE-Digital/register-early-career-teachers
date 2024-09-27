module Migration
  class Partnership < Migration::Base
    belongs_to :school
    belongs_to :lead_provider
    belongs_to :delivery_partner
    belongs_to :cohort
  end
end
