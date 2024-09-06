FactoryBot.define do
  factory(:school) do
    urn { Faker::Number.unique.decimal_part(digits: 7).to_s }
    name { Faker::Educator.primary_school + " (#{rand(100..999)})" }
  end
end
