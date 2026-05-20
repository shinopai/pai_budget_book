class Asset < ApplicationRecord
  # リレーション
  belongs_to :user

  # バリデーション
  validates :initial_amount,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }
end
