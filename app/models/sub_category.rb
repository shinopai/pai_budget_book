class SubCategory < ApplicationRecord
  # リレーション
  belongs_to :user
  belongs_to :category

  # バリデーション
  validates :name,
            presence: true,
            length: { maximum: 20 },
            uniqueness: { scope: :category_id }
end
