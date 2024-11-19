FactoryBot.define do
  factory(:appropriate_body) do
    sequence(:name) { |n| "Appropriate Body #{n}" }
    sequence(:local_authority_code, 100)
    sequence(:establishment_number, 1000)
    dfe_sign_in_organisation_id { SecureRandom.uuid }
  end
end
