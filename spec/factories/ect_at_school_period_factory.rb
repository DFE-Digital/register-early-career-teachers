FactoryBot.define do
  sequence(:base_ect_date) { |n| 2.years.ago.to_date + (3 * n).months }

  factory(:ect_at_school_period) do
    association :school
    association :teacher

    started_on { generate(:base_ect_date) }
    finished_on { started_on + 3.months }

    trait :active do
      finished_on { nil }
    end
  end
end
