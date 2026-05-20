class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーション
  validates :name, presence: true, length: { maximum: 20 }

  # リレーション
  has_many :categories, dependent: :destroy
  has_many :sub_categories, dependent: :destroy

  # コールバック
  after_create :copy_default_categories, unless: :admin?

  private

def copy_default_categories
  admin_user = User.find_by(admin: true)
  return unless admin_user

  admin_user.categories.includes(:sub_categories).find_each do |admin_category|
    new_category = categories.create!(
      name: admin_category.name
    )

    admin_category.sub_categories.each do |admin_sub_category|
      sub_categories.create!(
        category: new_category,
        name: admin_sub_category.name
      )
    end
  end
end
end
