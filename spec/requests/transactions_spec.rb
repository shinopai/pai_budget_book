require "rails_helper"

RSpec.describe "Transactions", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    let!(:category) { create(:category, user: user) }
    let!(:other_category) { create(:category, user: other_user) }

    let!(:sub_category) do
      create(:sub_category,
             user: user,
             category: category)
    end

    let!(:other_sub_category) do
      create(:sub_category,
             user: other_user,
             category: other_category)
    end

    let!(:transaction) do
      create(:transaction,
             user: user,
             sub_category: sub_category,
             memo: "昼食")
    end

    let!(:other_transaction) do
      create(:transaction,
             user: other_user,
             sub_category: other_sub_category,
             memo: "ガソリン")
    end

    before do
      sign_in user
    end

    it "取引一覧を表示できる" do
      get transactions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("昼食")
    end

    it "他ユーザーの取引は表示されない" do
      get transactions_path

      expect(response.body).to include("昼食")
      expect(response.body).not_to include("ガソリン")
    end
  end

  describe "GET /new" do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it "取引登録画面を表示できる" do
      get new_transaction_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user) }
    let!(:sub_category) do
      create(:sub_category,
            user: user,
            category: category)
    end

    before do
      sign_in user
    end

    context "有効なパラメータの場合" do
      it "取引を作成できる" do
        expect do
          post transactions_path, params: {
            transaction: {
              sub_category_id: sub_category.id,
              amount: 1_000,
              transaction_type: "expense",
              transacted_at: Date.current,
              memo: "昼食"
            }
          }
        end.to change(Transaction, :count).by(1)

        expect(response).to redirect_to(transactions_path)

        transaction = Transaction.last
        expect(transaction.amount).to eq(1_000)
        expect(transaction.memo).to eq("昼食")
        expect(transaction.user).to eq(user)
      end
    end

    context "無効なパラメータの場合" do
      it "取引を作成できない" do
        expect do
          post transactions_path, params: {
            transaction: {
              sub_category_id: sub_category.id,
              amount: "",
              transaction_type: "expense",
              transacted_at: Date.current,
              memo: "昼食"
            }
          }
        end.not_to change(Transaction, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /edit" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user) }
    let!(:sub_category) do
      create(:sub_category,
            user: user,
            category: category)
    end

    let!(:transaction) do
      create(:transaction,
            user: user,
            sub_category: sub_category)
    end

    before do
      sign_in user
    end

    it "取引編集画面を表示できる" do
      get edit_transaction_path(transaction)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /update" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user) }
    let!(:sub_category) do
      create(:sub_category,
            user: user,
            category: category)
    end

    let!(:transaction) do
      create(:transaction,
            user: user,
            sub_category: sub_category,
            amount: 1_000,
            memo: "昼食")
    end

    before do
      sign_in user
    end

    context "有効なパラメータの場合" do
      it "取引を更新できる" do
        patch transaction_path(transaction), params: {
          transaction: {
            sub_category_id: sub_category.id,
            amount: 2_000,
            transaction_type: transaction.transaction_type,
            transacted_at: transaction.transacted_at,
            memo: "夕食"
          }
        }

        expect(response).to redirect_to(transactions_path)

        transaction.reload
        expect(transaction.amount).to eq(2_000)
        expect(transaction.memo).to eq("夕食")
      end
    end

    context "無効なパラメータの場合" do
      it "取引を更新できない" do
        patch transaction_path(transaction), params: {
          transaction: {
            sub_category_id: sub_category.id,
            amount: "",
            transaction_type: transaction.transaction_type,
            transacted_at: transaction.transacted_at,
            memo: "夕食"
          }
        }

        expect(response).to have_http_status(:unprocessable_content)

        transaction.reload
        expect(transaction.amount).to eq(1_000)
        expect(transaction.memo).to eq("昼食")
      end
    end
  end

  describe "DELETE /destroy" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user) }
    let!(:sub_category) do
      create(:sub_category,
            user: user,
            category: category)
    end

    let!(:transaction) do
      create(:transaction,
            user: user,
            sub_category: sub_category)
    end

    before do
      sign_in user
    end

    it "取引を削除できる" do
      expect do
        delete transaction_path(transaction)
      end.to change(Transaction, :count).by(-1)

      expect(response).to redirect_to(transactions_path)
    end
  end

  describe "GET /copy" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user) }
    let!(:sub_category) do
      create(:sub_category,
            user: user,
            category: category)
    end

    let!(:transaction) do
      create(:transaction,
            user: user,
            sub_category: sub_category,
            amount: 1_000,
            memo: "昼食")
    end

    before do
      sign_in user
    end

    it "コピー用の新規画面を表示できる" do
      get copy_transaction_path(transaction)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("昼食")
    end
  end

  describe "POST /create save_as_template" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user) }
    let!(:sub_category) do
      create(:sub_category,
            user: user,
            category: category)
    end

    before do
      sign_in user
    end

    it "テンプレートも作成される" do
      expect do
        post transactions_path, params: {
          transaction: {
            sub_category_id: sub_category.id,
            amount: 1_000,
            transaction_type: "expense",
            transacted_at: Date.current,
            memo: "昼食"
          },
          save_as_template: "1"
        }
      end.to change(Template, :count).by(1)

      template = Template.last

      expect(template.user).to eq(user)
      expect(template.amount).to eq(1_000)
      expect(template.memo).to eq("昼食")
    end
  end

  describe "POST /create without save_as_template" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user) }
    let!(:sub_category) do
      create(:sub_category,
            user: user,
            category: category)
    end

    before do
      sign_in user
    end

    it "テンプレートは作成されない" do
      expect do
        post transactions_path, params: {
          transaction: {
            sub_category_id: sub_category.id,
            amount: 1_000,
            transaction_type: "expense",
            transacted_at: Date.current,
            memo: "昼食"
          }
        }
      end.not_to change(Template, :count)
    end
  end
end
