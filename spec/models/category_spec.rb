require "rails_helper"

RSpec.describe Category, type: :model do
  describe "バリデーション" do
    subject(:category) { build(:category) }

    it "有効なFactoryであれば有効であること" do
      expect(category).to be_valid
    end

    it "名前がなければ無効であること" do
      category.name = nil

      expect(category).not_to be_valid
    end

    it "名前が20文字以下であれば有効であること" do
      category.name = "あ" * 20

      expect(category).to be_valid
    end

    it "名前が21文字以上であれば無効であること" do
      category.name = "あ" * 21

      expect(category).not_to be_valid
    end

    it "ユーザーがなければ無効であること" do
      category.user = nil

      expect(category).not_to be_valid
    end
  end

  describe "リレーション" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:sub_categories).dependent(:restrict_with_error) }
  end
end
