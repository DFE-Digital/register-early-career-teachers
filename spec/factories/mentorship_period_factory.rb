FactoryBot.define do
  sequence(:base_mentorship_date) { |n| 2.years.ago.to_date + (3 * n).months }

  factory(:mentorship_period) do
    association :mentee, factory: :ect_at_school_period
    association :mentor, factory: :mentor_at_school_period

    started_on { generate(:base_mentorship_date) }
    finished_on { started_on + 3.months }

    trait :active do
      finished_on { nil }
    end
  end
end
