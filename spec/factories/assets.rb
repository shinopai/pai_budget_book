FactoryBot.define do
  factory :asset do
    association :user
    initial_amount { 100_000 }
  end
end
