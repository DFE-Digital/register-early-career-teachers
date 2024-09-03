FactoryBot.define do
  sequence(:base_training_date) { |n| 2.years.ago.to_date + (3 * n).months }

  factory(:training_period) do
    for_ect
    association :provider_partnership

    started_on { generate(:base_training_date) }
    finished_on { started_on + 3.months }

    trait :active do
      finished_on { nil }
    end

    trait(:for_ect) do
      association :trainee, factory: :ect_at_school_period
    end

    trait(:for_mentor) do
      association :trainee, factory: :mentor_at_school_period
    end
  end
end
