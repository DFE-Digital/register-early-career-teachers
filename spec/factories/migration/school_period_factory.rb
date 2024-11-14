FactoryBot.define do
  factory :school_period, class: "Migration::SchoolPeriod" do
    urn { Faker::Number.unique.decimal_part(digits: 6).to_s }
    start_date { 1.month.ago.to_date }
    end_date { 1.day.ago.to_date }
    start_source_id { SecureRandom.uuid }
    end_source_id { SecureRandom.uuid }

    initialize_with { new(**attributes) }
  end
end
