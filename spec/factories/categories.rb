FactoryBot.define do
  factory :category do
    association :user
    name { "食費" }
  end
end
