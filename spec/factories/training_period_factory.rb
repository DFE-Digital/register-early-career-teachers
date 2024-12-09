FactoryBot.define do
  sequence(:base_training_date) { |n| 2.years.ago.to_date + (5 * n).days }

  factory(:training_period) do
    for_ect
    association :provider_partnership

    started_on { generate(:base_training_date) }
    finished_on { started_on + 5.days }

    trait :active do
      finished_on { nil }
    end

    trait(:for_ect) do
      association :ect_at_school_period
      mentor_at_school_period { nil }
    end

    trait(:for_mentor) do
      association :mentor_at_school_period
      ect_at_school_period { nil }
    end
  end
end
