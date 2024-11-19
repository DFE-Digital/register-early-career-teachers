FactoryBot.define do
  factory :mentorship_period_data, class: "Migration::MentorshipPeriodData" do
    mentor_teacher factory: :teacher
    start_date { 2.years.ago.to_date }
    end_date { 1.month.ago.to_date }
    start_source_id { SecureRandom.uuid }
    end_source_id { SecureRandom.uuid }

    initialize_with { new(**attributes) }
  end
end
