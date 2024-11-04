FactoryBot.define do
  factory :induction_extension do
    association :teacher

    number_of_terms { 1.2 }
  end
end
