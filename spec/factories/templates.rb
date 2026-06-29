FactoryBot.define do
  factory :template do
    association :sub_category
    user { sub_category.user }

    amount { 1_000 }
    transaction_type { :expense }
    memo { "昼食" }
  end
end
