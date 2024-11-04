FactoryBot.define do
  factory(:induction_period) do
    association :appropriate_body
    association :teacher

    started_on { 1.year.ago }
    finished_on { 1.month.ago }
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
