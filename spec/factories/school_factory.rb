FactoryBot.define do
  factory(:school) do
    urn { Faker::Number.unique.decimal_part(digits: 7).to_s }
    gias_school { association :gias_school, urn: }
  end
end
