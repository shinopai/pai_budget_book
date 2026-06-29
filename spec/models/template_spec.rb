require "rails_helper"

RSpec.describe Template, type: :model do
  describe "バリデーション" do
    subject(:template) { build(:template) }

    it "有効なFactoryであれば有効であること" do
      expect(template).to be_valid
    end

    it "金額がなければ無効であること" do
      template.amount = nil

      expect(template).not_to be_valid
    end

    it "金額が1以上であれば有効であること" do
      template.amount = 1

      expect(template).to be_valid
    end

    it "金額が0以下であれば無効であること" do
      template.amount = 0

      expect(template).not_to be_valid
    end

    it "金額が999,999以下であれば有効であること" do
      template.amount = 999_999

      expect(template).to be_valid
    end

    it "金額が1,000,000以上であれば無効であること" do
      template.amount = 1_000_000

      expect(template).not_to be_valid
    end

    it "取引種別がなければ無効であること" do
      template.transaction_type = nil

      expect(template).not_to be_valid
    end

    it "メモが300文字以下であれば有効であること" do
      template.memo = "あ" * 300

      expect(template).to be_valid
    end

    it "メモが301文字以上であれば無効であること" do
      template.memo = "あ" * 301

      expect(template).not_to be_valid
    end

    it "ユーザーがなければ無効であること" do
      template.user = nil

      expect(template).not_to be_valid
    end

    it "サブカテゴリーがなければ無効であること" do
      template.sub_category = nil

      expect(template).not_to be_valid
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

  describe "#display_name" do
  let(:sub_category) { create(:sub_category, name: "食費") }

  it "メモがある場合はメモを表示すること" do
    template = build(
      :template,
      sub_category: sub_category,
      user: sub_category.user,
      transaction_type: :expense,
      amount: 1000,
      memo: "昼食"
    )

    expect(template.display_name).to eq("支出 / 1000円 / 昼食")
  end

  it "メモがない場合はサブカテゴリー名を表示すること" do
    template = build(
      :template,
      sub_category: sub_category,
      user: sub_category.user,
      transaction_type: :income,
      amount: 5000,
      memo: ""
    )

    expect(template.display_name).to eq("収入 / 5000円 / 食費")
  end
end
end
