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

  category_names = [
    "食費",
    "日用品",
    "住居費",
    "水道光熱費",
    "通信費",
    "交通費",
    "医療費",
    "美容費",
    "被服費",
    "娯楽費",
    "交際費",
    "教育費",
    "保険",
    "税金",
    "特別費",
    "その他",
    "給与",
    "副業収入",
    "投資収入",
    "臨時収入",
    "その他収入"
  ]

  category_names.each do |name|
    Category.find_or_create_by!(
      user: admin_user,
      name: name
    )
  end
end
