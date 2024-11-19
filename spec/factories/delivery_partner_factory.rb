FactoryBot.define do
  factory(:delivery_partner) do
    sequence(:name) { |n| "Delivery Partner #{n}" }
  end
end
