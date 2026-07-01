require "rails_helper"

RSpec.describe "Admin::SubCategories", type: :request do
  let(:admin) { create(:user, admin: true) }

  describe "GET /index" do
    let!(:category) do
      create(:category, user: admin, name: "食費")
    end

    let!(:sub_category) do
      create(
        :sub_category,
        user: admin,
        category: category,
        name: "昼食"
      )
    end

    let!(:other_category) do
      create(:category, name: "趣味")
    end

    let!(:other_sub_category) do
      create(
        :sub_category,
        category: other_category,
        name: "映画"
      )
    end

    before do
      sign_in admin
    end

    it "サブカテゴリー一覧を表示できる" do
      get admin_sub_categories_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("昼食")
    end

    it "自分のサブカテゴリーのみ表示される" do
      get admin_sub_categories_path

      expect(response.body).to include("昼食")
      expect(response.body).not_to include("映画")
    end
  end

  describe "POST /create" do
    let!(:category) do
      create(:category, user: admin)
    end

    before do
      sign_in admin
    end

    context "有効なパラメータの場合" do
      it "サブカテゴリーを作成できる" do
        expect do
          post admin_sub_categories_path, params: {
            sub_category: {
              category_id: category.id,
              name: "交通費"
            }
          }
        end.to change(SubCategory, :count).by(1)

        expect(response).to redirect_to(admin_sub_categories_path)
      end
    end

    context "無効なパラメータの場合" do
      it "サブカテゴリーを作成できない" do
        expect do
          post admin_sub_categories_path, params: {
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
    let!(:category) do
      create(:category, user: admin)
    end

    let!(:sub_category) do
      create(
        :sub_category,
        user: admin,
        category: category,
        name: "昼食"
      )
    end

    before do
      sign_in admin
    end

    context "有効なパラメータの場合" do
      it "サブカテゴリーを更新できる" do
        patch admin_sub_category_path(sub_category), params: {
          sub_category: {
            category_id: category.id,
            name: "夕食"
          }
        }

        expect(response).to redirect_to(admin_sub_categories_path)
        expect(sub_category.reload.name).to eq("夕食")
      end
    end

    context "無効なパラメータの場合" do
      it "サブカテゴリーを更新できない" do
        patch admin_sub_category_path(sub_category), params: {
          sub_category: {
            category_id: category.id,
            name: ""
          }
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(sub_category.reload.name).to eq("昼食")
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:category) do
      create(:category, user: admin)
    end

    before do
      sign_in admin
    end

    context "関連する取引がない場合" do
      let!(:sub_category) do
        create(
          :sub_category,
          user: admin,
          category: category
        )
      end

      it "サブカテゴリーを削除できる" do
        expect do
          delete admin_sub_category_path(sub_category)
        end.to change(SubCategory, :count).by(-1)

        expect(response).to redirect_to(admin_sub_categories_path)
      end
    end

    context "関連する取引が存在する場合" do
      let!(:sub_category) do
        create(
          :sub_category,
          user: admin,
          category: category
        )
      end

      let!(:transaction) do
        create(
          :transaction,
          user: admin,
          sub_category: sub_category
        )
      end

      it "関連する取引も一緒に削除される" do
        expect do
          delete admin_sub_category_path(sub_category)
        end.to change(SubCategory, :count).by(-1)
          .and change(Transaction, :count).by(-1)

        expect(response).to redirect_to(admin_sub_categories_path)
      end
    end
  end
end
