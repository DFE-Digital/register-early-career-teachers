FactoryBot.define do
  sequence(:base_academic_year, 2021)

  factory(:academic_year) do
    year { generate(:base_academic_year) }
  end
end
