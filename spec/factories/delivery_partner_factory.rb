FactoryBot.define do
  factory(:delivery_partner) do
    name { "#{Faker::Lorem.word.capitalize} DP" }
  end
end
