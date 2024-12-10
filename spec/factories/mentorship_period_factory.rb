FactoryBot.define do
  sequence(:base_mentorship_date) { |n| 2.years.ago.to_date + (5 * n).days }

  factory(:mentorship_period) do
    started_on { generate(:base_mentorship_date) }
    finished_on { started_on + 5.days }

    trait :active do
      finished_on { nil }
    end
  end
end
