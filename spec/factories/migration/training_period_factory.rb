FactoryBot.define do
  factory :training_period_data, class: "Migration::TrainingPeriodData" do
    training_programme { "full_induction_programme" }
    lead_provider { "Ace Provider" }
    delivery_partner { "Whizzy Delivery" }
    core_materials { nil }
    cohort_year { 2.years.ago.year }
    start_date { 2.years.ago.to_date }
    end_date { 1.month.ago.to_date }
    start_source_id { SecureRandom.uuid }
    end_source_id { SecureRandom.uuid }

    initialize_with { new(**attributes) }
  end
end
