FactoryBot.define do
  factory :round do
    game
    description { "40 - 10" }
    correct_answer { 30 }
    current { true }
    alternatives { [10, 20, 30, 40] }
  end
end
