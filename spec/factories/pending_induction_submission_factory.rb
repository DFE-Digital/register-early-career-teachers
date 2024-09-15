FactoryBot.define do
  factory(:pending_induction_submission) do
    sequence(:trn, 3_000_000)
    date_of_birth { Faker::Date.between(from: 80.years.ago, to: 20.years.ago) }
  end
end
