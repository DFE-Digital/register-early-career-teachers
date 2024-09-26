FactoryBot.define do
  factory(:gias_school_link, class: GIAS::SchoolLink) do
    association :from_gias_school, factory: :gias_school
    association :to_gias_school, factory: :gias_school

    link_date { Faker::Date.between(from: 2.months.ago, to: Date.yesterday) }
    link_type { GIAS::SchoolLink::LINK_TYPES.sample }
  end
end
