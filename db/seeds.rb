# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 管理者作成
# if Rails.env.development?
#   User.find_or_create_by!(email: "admin@example.com") do |user|
#     user.name = "管理者"
#     user.password = "password123"
#     user.password_confirmation = "password123"
#     user.admin = true
#   end
# end

# カテゴリ作成
if Rails.env.development?
  admin_user = User.find_by!(email: "admin@example.com")

  # category_names = [
  #   "食費",
  #   "日用品",
  #   "住居費",
  #   "水道光熱費",
  #   "通信費",
  #   "交通費",
  #   "医療費",
  #   "美容費",
  #   "被服費",
  #   "娯楽費",
  #   "交際費",
  #   "教育費",
  #   "保険",
  #   "税金",
  #   "特別費",
  #   "その他",
  #   "給与",
  #   "副業収入",
  #   "投資収入",
  #   "臨時収入",
  #   "その他収入"
  # ]

  # category_names.each do |name|
  #   Category.find_or_create_by!(
  #     user: admin_user,
  #     name: name
  #   )
  # end

#   sub_categories_data = {
#   "食費" => ["外食", "スーパー", "コンビニ", "カフェ"],
#   "日用品" => ["消耗品", "生活雑貨"],
#   "住居費" => ["家賃", "管理費"],
#   "水道光熱費" => ["電気代", "ガス代", "水道代"],
#   "通信費" => ["携帯料金", "インターネット"],
#   "交通費" => ["電車", "バス", "タクシー", "ガソリン", "駐車場"],
#   "医療費" => ["病院", "薬"],
#   "美容費" => ["美容院", "化粧品"],
#   "被服費" => ["洋服", "靴", "バッグ"],
#   "娯楽費" => ["映画", "ゲーム", "旅行"],
#   "交際費" => ["飲み会", "プレゼント"],
#   "教育費" => ["書籍", "受講料"],
#   "保険" => ["生命保険", "医療保険"],
#   "税金" => ["住民税", "所得税"],
#   "特別費" => ["家電", "家具"],
#   "その他" => ["その他支出"],
#   "給与" => ["給与"],
#   "副業収入" => ["副業"],
#   "投資収入" => ["配当金", "売却益"],
#   "臨時収入" => ["祝い金", "返金"],
#   "その他収入" => ["その他収入"]
# }

# sub_categories_data.each do |category_name, sub_category_names|
#   category = admin_user.categories.find_by(name: category_name)
#   next unless category

#   sub_category_names.each do |sub_category_name|
#     admin_user.sub_categories.find_or_create_by!(
#       category: category,
#       name: sub_category_name
#     )
#   end
# end
#
# 支出テストデータ作成
user = User.find(3)

[
  "食費",
  "日用品",
  "水道光熱費",
  "通信費",
  "交際費",
  "医療費",
  "美容費"
].each do |category_name|

  category = user.categories.find_by(name: category_name)

  next unless category

  user.sub_categories.find_or_create_by!(
    category: category,
    name: "#{category_name}その他"
  )
end

[
  ["食費その他", 1200, "昼食"],
  ["食費その他", 2500, "スーパー"],
  ["食費その他", 1800, "外食"],
  ["日用品その他", 980, "洗剤"],
  ["日用品その他", 650, "ティッシュ"],
  ["通信費その他", 4980, "スマホ料金"],
  ["水道光熱費その他", 7200, "電気代"],
  ["交際費その他", 4500, "飲み会"],
  ["美容費その他", 3800, "美容院"],
  ["医療費その他", 2200, "歯医者"]
].each do |sub_category_name, amount, memo|

  sub_category = user.sub_categories.find_by(name: sub_category_name)

  Transaction.create!(
    user: user,
    sub_category: sub_category,
    transaction_type: :expense,
    amount: amount,
    transacted_at: Date.current,
    memo: memo
  )
end
end
