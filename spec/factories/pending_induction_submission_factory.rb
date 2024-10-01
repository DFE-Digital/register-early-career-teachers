FactoryBot.define do
  factory(:pending_induction_submission) do
    association :appropriate_body
    sequence(:trn, 3_000_000)
    date_of_birth { Faker::Date.between(from: 80.years.ago, to: 20.years.ago) }
    trs_first_name { Faker::Name.first_name }
    trs_last_name { Faker::Name.last_name }
    started_on { 1.year.ago }
  end
end
