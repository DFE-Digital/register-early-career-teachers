FactoryBot.define do
  factory(:appropriate_body) do
    name { "#{Faker::Lorem.word.capitalize} AB" }
  end
end
