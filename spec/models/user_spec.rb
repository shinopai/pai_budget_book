require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    subject(:user) { build(:user) }

    it "有効なFactoryであれば有効であること" do
      expect(user).to be_valid
    end

    it "名前がなければ無効であること" do
      user.name = nil

      expect(user).not_to be_valid
    end

    it "メールアドレスがなければ無効であること" do
      user.email = nil

      expect(user).not_to be_valid
    end

    it "メールアドレスが重複している場合は無効であること" do
      create(:user)

      user = build(:user, email: User.first.email)

      expect(user).not_to be_valid
    end

    it "正しいメールアドレス形式であれば有効であること" do
      user.email = "test@example.com"

      expect(user).to be_valid
    end

      it "メールアドレス形式が不正な場合は無効であること" do
        user.email = "invalid_email"

        expect(user).not_to be_valid
      end

    it "名前が20文字以下であれば有効であること" do
      user.name = "a" * 20

      expect(user).to be_valid
    end

    it "名前が21文字以上であれば無効であること" do
      user.name = "a" * 21

      expect(user).not_to be_valid
    end
  end

  describe "リレーション" do
  it { is_expected.to have_many(:transactions).dependent(:destroy) }
  it { is_expected.to have_many(:categories).dependent(:destroy) }
  it { is_expected.to have_many(:sub_categories).dependent(:destroy) }
  it { is_expected.to have_many(:templates).dependent(:destroy) }
  it { is_expected.to have_one(:asset).dependent(:destroy) }
end
end
