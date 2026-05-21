class Transaction < ApplicationRecord
  # リレーション
  belongs_to :user
  belongs_to :sub_category

  # enum
  enum :transaction_type, {
    expense: 0,
    income: 1
  }

  # バリデーション
  validates :amount,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 999_999
            }

  validates :transaction_type, presence: true
  validates :transacted_at, presence: true
  validates :memo, length: { maximum: 300 }, allow_blank: true
end
