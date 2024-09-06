FactoryBot.define do
  factory(:teacher) do
    name { [Faker::Name.name, Faker::Name.last_name].join(" ") }
  end
end
