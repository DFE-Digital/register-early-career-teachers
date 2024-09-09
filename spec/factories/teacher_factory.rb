FactoryBot.define do
  factory(:teacher) do
    sequence(:trn, 1_000_000)
    name { [Faker::Name.name, Faker::Name.last_name].join(" ") }
  end
end
