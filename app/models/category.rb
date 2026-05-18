class Category < ApplicationRecord
  # リレーション
  belongs_to :user

  # バリデーション
  validates :name,
            presence: true,
            length: { maximum: 20 },
            uniqueness: { scope: :user_id }
end
