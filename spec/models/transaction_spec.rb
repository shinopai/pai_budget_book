require "rails_helper"

RSpec.describe Transaction, type: :model do
  describe "バリデーション" do
    subject(:transaction) { build(:transaction) }

    it "有効なFactoryであれば有効であること" do
      expect(transaction).to be_valid
    end

    it "金額がなければ無効であること" do
      transaction.amount = nil

      expect(transaction).not_to be_valid
    end

    it "金額が1以上であれば有効であること" do
      transaction.amount = 1

      expect(transaction).to be_valid
    end

    it "金額が0以下であれば無効であること" do
      transaction.amount = 0

      expect(transaction).not_to be_valid
    end

    it "金額が999,999以下であれば有効であること" do
      transaction.amount = 999_999

      expect(transaction).to be_valid
    end

    it "金額が1,000,000以上であれば無効であること" do
      transaction.amount = 1_000_000

      expect(transaction).not_to be_valid
    end

    it "取引種別がなければ無効であること" do
      transaction.transaction_type = nil

      expect(transaction).not_to be_valid
    end

    it "取引日がなければ無効であること" do
      transaction.transacted_at = nil

      expect(transaction).not_to be_valid
    end

    it "メモが300文字以下であれば有効であること" do
      transaction.memo = "あ" * 300

      expect(transaction).to be_valid
    end

    it "メモが301文字以上であれば無効であること" do
      transaction.memo = "あ" * 301

      expect(transaction).not_to be_valid
    end

    it "ユーザーがなければ無効であること" do
      transaction.user = nil

      expect(transaction).not_to be_valid
    end

    it "サブカテゴリーがなければ無効であること" do
      transaction.sub_category = nil

      expect(transaction).not_to be_valid
    end
  end

  describe "リレーション" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:sub_category) }
  end

  describe "enum" do
    it do
      expect(described_class.transaction_types)
        .to eq({ "expense" => 0, "income" => 1 })
    end
  end
end
