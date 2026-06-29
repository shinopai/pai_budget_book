require "rails_helper"

RSpec.describe SubCategory, type: :model do
  describe "バリデーション" do
    subject(:sub_category) { build(:sub_category) }

    it "有効なFactoryであれば有効であること" do
      expect(sub_category).to be_valid
    end

    it "名前がなければ無効であること" do
      sub_category.name = nil

      expect(sub_category).not_to be_valid
    end

    it "名前が20文字以下であれば有効であること" do
      sub_category.name = "あ" * 20

      expect(sub_category).to be_valid
    end

    it "名前が21文字以上であれば無効であること" do
      sub_category.name = "あ" * 21

      expect(sub_category).not_to be_valid
    end

    it "ユーザーがなければ無効であること" do
      sub_category.user = nil

      expect(sub_category).not_to be_valid
    end

    it "カテゴリーがなければ無効であること" do
      sub_category.category = nil

      expect(sub_category).not_to be_valid
    end

    it "同一カテゴリー内で名前が重複している場合は無効であること" do
      category = create(:category)
      create(:sub_category, category: category, user: category.user, name: "スーパー")

      duplicate = build(:sub_category, category: category, user: category.user, name: "スーパー")

      expect(duplicate).not_to be_valid
    end

    it "異なるカテゴリーであれば同じ名前でも有効であること" do
      category1 = create(:category)
      category2 = create(:category)

      create(:sub_category, category: category1, user: category1.user, name: "スーパー")

      sub_category = build(
        :sub_category,
        category: category2,
        user: category2.user,
        name: "スーパー"
      )

      expect(sub_category).to be_valid
    end
  end

  describe "リレーション" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category) }

    it { is_expected.to have_many(:transactions).dependent(:destroy) }
    it { is_expected.to have_many(:templates).dependent(:destroy) }
  end
end
