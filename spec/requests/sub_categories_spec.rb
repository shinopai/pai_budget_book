require "rails_helper"

RSpec.describe "SubCategories", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    let!(:category) { create(:category, user: user) }
    let!(:other_category) { create(:category, user: other_user) }

    let!(:sub_category) do
      create(:sub_category,
             user: user,
             category: category,
             name: "スーパー")
    end

    let!(:other_sub_category) do
      create(:sub_category,
             user: other_user,
             category: other_category,
             name: "ガソリン")
    end

    before do
      sign_in user
    end

    it "サブカテゴリー一覧を表示できる" do
      get sub_categories_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("スーパー")
    end

    it "他ユーザーのサブカテゴリーは表示されない" do
      get sub_categories_path

      expect(response.body).to include("スーパー")
      expect(response.body).not_to include("ガソリン")
    end
  end

  describe "POST /create" do
  let(:user) { create(:user) }
  let!(:category) { create(:category, user: user) }

  before do
    sign_in user
  end

  context "有効なパラメータの場合" do
    it "サブカテゴリーを作成できる" do
      expect do
        post sub_categories_path, params: {
          sub_category: {
            category_id: category.id,
            name: "スーパー"
          }
        }
      end.to change(SubCategory, :count).by(1)

      expect(response).to redirect_to(sub_categories_path)
    end
  end

  context "無効なパラメータの場合" do
    it "サブカテゴリーを作成できない" do
      expect do
        post sub_categories_path, params: {
          sub_category: {
            category_id: category.id,
            name: ""
          }
        }
      end.not_to change(SubCategory, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
  end

  describe "PATCH /update" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user) }

    let!(:sub_category) do
      create(:sub_category,
            user: user,
            category: category,
            name: "スーパー")
    end

    before do
      sign_in user
    end

    context "有効なパラメータの場合" do
      it "サブカテゴリーを更新できる" do
        patch sub_category_path(sub_category), params: {
          sub_category: {
            category_id: category.id,
            name: "コンビニ"
          }
        }

        expect(response).to redirect_to(sub_categories_path)
        expect(sub_category.reload.name).to eq("コンビニ")
      end
    end

    context "無効なパラメータの場合" do
      it "サブカテゴリーを更新できない" do
        patch sub_category_path(sub_category), params: {
          sub_category: {
            category_id: category.id,
            name: ""
          }
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(sub_category.reload.name).to eq("スーパー")
      end
    end
  end

  describe "DELETE /destroy" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user) }

    before do
      sign_in user
    end

    context "削除可能な場合" do
      let!(:sub_category) do
        create(:sub_category,
              user: user,
              category: category)
      end

      it "サブカテゴリーを削除できる" do
        expect do
          delete sub_category_path(sub_category)
        end.to change(SubCategory, :count).by(-1)

        expect(response).to redirect_to(sub_categories_path)
      end
    end

    context "取引が存在する場合" do
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

      it "サブカテゴリーを削除できない" do
        expect do
          delete sub_category_path(sub_category)
        end.not_to change(SubCategory, :count)

        expect(response).to redirect_to(sub_categories_path)
        expect(SubCategory.exists?(sub_category.id)).to be true
      end
    end
  end
end
