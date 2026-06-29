require "rails_helper"

RSpec.describe Asset, type: :model do
  describe "バリデーション" do
    subject(:asset) { build(:asset) }

    it "有効なFactoryであれば有効であること" do
      expect(asset).to be_valid
    end

    it "初期資産がなければ無効であること" do
      asset.initial_amount = nil

      expect(asset).not_to be_valid
    end

    it "初期資産が0以上であれば有効であること" do
      asset.initial_amount = 0

      expect(asset).to be_valid
    end

    it "初期資産が負の値であれば無効であること" do
      asset.initial_amount = -1

      expect(asset).not_to be_valid
    end

    it "ユーザーがなければ無効であること" do
      asset.user = nil

      expect(asset).not_to be_valid
    end
  end

  describe "リレーション" do
    it { is_expected.to belong_to(:user) }
  end
end
