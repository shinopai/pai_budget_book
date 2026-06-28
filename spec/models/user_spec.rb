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

    it "名前が20文字以下であれば有効であること" do
      user.name = "a" * 20

      expect(user).to be_valid
    end

    it "名前が21文字以上であれば無効であること" do
      user.name = "a" * 21

      expect(user).not_to be_valid
    end
  end
end
