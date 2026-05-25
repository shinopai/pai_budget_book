class SubCategory < ApplicationRecord
  # リレーション
  belongs_to :user
  belongs_to :category
  has_many :transactions, dependent: :destroy
  has_many :templates, dependent: :destroy

  # バリデーション
  validates :name,
            presence: true,
            length: { maximum: 20 },
            uniqueness: { scope: :category_id }
end
