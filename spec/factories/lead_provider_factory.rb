FactoryBot.define do
  factory(:lead_provider) do
    name { "#{Faker::Lorem.word.capitalize} LP (#{rand(100..999)})" }
  end
end
