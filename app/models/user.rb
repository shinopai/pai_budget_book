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
end
