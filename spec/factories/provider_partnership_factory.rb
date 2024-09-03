FactoryBot.define do
  factory(:provider_partnership) do
    association :academic_year
    association :lead_provider
    association :delivery_partner
  end
end
