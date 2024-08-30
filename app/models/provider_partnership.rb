class ProviderPartnership < ApplicationRecord
  belongs_to :academic_year
  belongs_to :lead_provider
  belongs_to :delivery_partner
end
