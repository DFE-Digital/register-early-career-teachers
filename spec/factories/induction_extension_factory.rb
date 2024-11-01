FactoryBot.define do
  factory :induction_extension do
    association :teacher

    extension_terms { 1.2 }
  end
end
