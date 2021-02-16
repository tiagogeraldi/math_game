FactoryBot.define do
  factory :game do
    association :user_one, factory: :user
    association :user_two, factory: :user
  end
end
