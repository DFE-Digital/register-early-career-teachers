FactoryBot.define do
  factory(:lead_provider) do
    name { "#{Faker::Lorem.word.capitalize} LP" }
  end
end
