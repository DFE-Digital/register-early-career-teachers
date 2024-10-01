FactoryBot.define do
  factory(:induction_period) do
    association :appropriate_body
    association :ect_at_school_period

    started_on { ect_at_school_period.started_on + 1.month }
    finished_on { ect_at_school_period.finished_on - 1.month if ect_at_school_period.finished_on }
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
