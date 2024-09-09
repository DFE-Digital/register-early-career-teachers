FactoryBot.define do
  sequence(:base_induction_date) { |n| 2.years.ago.to_date + (3 * n).months }

  factory(:induction_period) do
    association :appropriate_body
    association :ect_at_school_period

    started_on { generate(:base_induction_date) }
    finished_on { started_on + 3.months }
    number_of_terms { Faker::Number.within(range: 1..6) }
    induction_programme { "fip" }

    trait :active do
      finished_on { nil }
      number_of_terms { nil }
    end

    trait(:cip) { induction_programme { "cip" } }
    trait(:diy) { induction_programme { "diy" } }
  end
end
