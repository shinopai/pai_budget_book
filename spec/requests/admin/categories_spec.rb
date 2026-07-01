require "rails_helper"

RSpec.describe "Admin::Categories", type: :request do
  let(:admin) { create(:user, :admin) }

  describe "GET /index" do
    let!(:category) do
      create(:category, user: admin, name: "食費")
    end

    let!(:other_category) do
      create(:category, name: "趣味")
    end

    before do
      sign_in admin
    end

    it "カテゴリー一覧を表示できる" do
      get admin_categories_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("食費")
    end

    it "自分のカテゴリーのみ表示される" do
      get admin_categories_path

      expect(response.body).to include("食費")
      expect(response.body).not_to include("趣味")
    end
  end

  describe "POST /create" do
    before do
      sign_in admin
    end

    context "有効なパラメータの場合" do
      it "カテゴリーを作成できる" do
        expect do
          post admin_categories_path, params: {
            category: {
              name: "交通費"
            }
          }
        end.to change(Category, :count).by(1)

        expect(response).to redirect_to(admin_categories_path)
      end
    end

    context "無効なパラメータの場合" do
      it "カテゴリーを作成できない" do
        expect do
          post admin_categories_path, params: {
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
    let!(:category) do
      create(:category, user: admin, name: "食費")
    end

    before do
      sign_in admin
    end

    context "有効なパラメータの場合" do
      it "カテゴリーを更新できる" do
        patch admin_category_path(category), params: {
          category: {
            name: "交通費"
          }
        }

        expect(response).to redirect_to(admin_categories_path)
        expect(category.reload.name).to eq("交通費")
      end
    end

    context "無効なパラメータの場合" do
      it "カテゴリーを更新できない" do
        patch admin_category_path(category), params: {
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
    before do
      sign_in admin
    end

    context "削除可能な場合" do
      let!(:category) do
        create(:category, user: admin)
      end

      it "カテゴリーを削除できる" do
        expect do
          delete admin_category_path(category)
        end.to change(Category, :count).by(-1)

        expect(response).to redirect_to(admin_categories_path)
      end
    end

    context "サブカテゴリーが存在する場合" do
      let!(:category) do
        create(:category, user: admin)
      end

      let!(:sub_category) do
        create(:sub_category, user: admin, category: category)
      end

      it "カテゴリーを削除できない" do
        expect do
          delete admin_category_path(category)
        end.not_to change(Category, :count)

        expect(response).to redirect_to(admin_categories_path)
        expect(Category.exists?(category.id)).to be(true)
      end
    end
  end
end
