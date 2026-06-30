require "rails_helper"

RSpec.describe "Categories", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    let!(:category) do
      create(:category, user: user, name: "食費")
    end

    let!(:other_category) do
      create(:category, user: other_user, name: "趣味")
    end

    before do
      sign_in user
    end

    it "カテゴリー一覧を表示できる" do
      get categories_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("食費")
    end

    it "他ユーザーのカテゴリーは表示されない" do
      get categories_path

      expect(response.body).to include("食費")
      expect(response.body).not_to include("趣味")
    end
  end

  describe "POST /create" do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  context "有効なパラメータの場合" do
    it "カテゴリーを作成できる" do
      expect do
        post categories_path, params: {
          category: {
            name: "交通費"
          }
        }
      end.to change(Category, :count).by(1)

      expect(response).to redirect_to(categories_path)
    end
  end

  context "無効なパラメータの場合" do
    it "カテゴリーを作成できない" do
      expect do
        post categories_path, params: {
          category: {
            name: ""
          }
        }
      end.not_to change(Category, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
  end

  describe "PATCH /update" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user, name: "食費") }

    before do
      sign_in user
    end

    context "有効なパラメータの場合" do
      it "カテゴリーを更新できる" do
        patch category_path(category), params: {
          category: {
            name: "交通費"
          }
        }

        expect(response).to redirect_to(categories_path)
        expect(category.reload.name).to eq("交通費")
      end
    end

    context "無効なパラメータの場合" do
      it "カテゴリーを更新できない" do
        patch category_path(category), params: {
          category: {
            name: ""
          }
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(category.reload.name).to eq("食費")
      end
    end
  end

  describe "DELETE /destroy" do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    context "削除可能な場合" do
      let!(:category) { create(:category, user: user) }

      it "カテゴリーを削除できる" do
        expect do
          delete category_path(category)
        end.to change(Category, :count).by(-1)

        expect(response).to redirect_to(categories_path)
      end
    end

    context "サブカテゴリーが存在する場合" do
      let!(:category) { create(:category, user: user) }
      let!(:sub_category) { create(:sub_category, user: user, category: category) }

      it "カテゴリーを削除できない" do
        expect do
          delete category_path(category)
        end.not_to change(Category, :count)

        expect(response).to redirect_to(categories_path)
        expect(Category.exists?(category.id)).to be true
      end
    end
  end
end
