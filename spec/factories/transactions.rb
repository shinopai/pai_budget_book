FactoryBot.define do
  factory :transaction do
    association :sub_category
    user { sub_category.user }

    amount { 1_000 }
    transaction_type { :expense }
    transacted_at { Date.current }
    memo { "昼食" }
  end
end
