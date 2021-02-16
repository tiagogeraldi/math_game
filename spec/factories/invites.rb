FactoryBot.define do
  factory :invite do
    association :from, factory: :user
    association :to, factory: :user

    trait :with_game do
      game
    end
  end
end
