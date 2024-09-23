FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "john.doe#{n}@example.com" }
    sequence(:name) { |n| "John Doe #{n}" }

    trait :admin do
      after(:create) do |user|
        FactoryBot.create(:dfe_role, user:)
      end
    end

    trait :appropriate_body_user do
      after(:create) do |user|
        FactoryBot.create(
          :appropriate_body_role,
          user:,
          appropriate_body: FactoryBot.create(:appropriate_body)
        )
      end
    end
  end
end
