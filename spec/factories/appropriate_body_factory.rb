FactoryBot.define do
  factory(:appropriate_body) do
    name { "#{Faker::Lorem.unique.word.capitalize} AB" }
    sequence(:local_authority_code, 100)
    sequence(:establishment_number, 1000)
  end
end
