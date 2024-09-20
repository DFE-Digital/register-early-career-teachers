FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "john.doe#{n}@example.com" }
    sequence(:name) { |n| "John Doe #{n}" }

    trait :admin do
      after(:create) do |user|
        FactoryBot.create(:dfe_role, user:)
      end
    end
  end
end
