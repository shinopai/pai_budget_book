FactoryBot.define do
  factory :sub_category do
    association :category
    user { category.user }
    name { "スーパー" }
  end
end
