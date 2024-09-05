FactoryBot.define do
  factory(:delivery_partner) do
    name { "#{Faker::Lorem.word.capitalize} DP (#{rand(100..999)})" }
  end
end
