require "rails_helper"

RSpec.describe "Templates", type: :request do
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

    let!(:template) do
      create(:template,
             user: user,
             sub_category: sub_category,
             memo: "昼食")
    end

    let!(:other_template) do
      create(:template,
             user: other_user,
             sub_category: other_sub_category,
             memo: "ガソリン")
    end

    before do
      sign_in user
    end

    it "テンプレート一覧を表示できる" do
      get templates_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("昼食")
    end

    it "他ユーザーのテンプレートは表示されない" do
      get templates_path

      expect(response.body).to include("昼食")
      expect(response.body).not_to include("ガソリン")
    end
  end

  describe "GET /edit" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user) }
    let!(:sub_category) { create(:sub_category, user: user, category: category) }

    let!(:template) do
      create(:template,
            user: user,
            sub_category: sub_category)
    end

    before do
      sign_in user
    end

    it "テンプレート編集画面を表示できる" do
      get edit_template_path(template)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /update" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user) }
    let!(:sub_category) { create(:sub_category, user: user, category: category) }

    let!(:template) do
      create(:template,
            user: user,
            sub_category: sub_category,
            memo: "昼食")
    end

    before do
      sign_in user
    end

    context "有効なパラメータの場合" do
      it "テンプレートを更新できる" do
        patch template_path(template), params: {
          template: {
            transaction_type: template.transaction_type,
            amount: template.amount,
            sub_category_id: sub_category.id,
            memo: "夕食"
          }
        }

        expect(response).to redirect_to(templates_path)
        expect(template.reload.memo).to eq("夕食")
      end
    end

    context "無効なパラメータの場合" do
      it "テンプレートを更新できない" do
        patch template_path(template), params: {
          template: {
            transaction_type: template.transaction_type,
            amount: "",
            sub_category_id: sub_category.id,
            memo: "夕食"
          }
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(template.reload.memo).to eq("昼食")
      end
    end
  end

  describe "DELETE /destroy" do
    let(:user) { create(:user) }
    let!(:category) { create(:category, user: user) }
    let!(:sub_category) { create(:sub_category, user: user, category: category) }

    let!(:template) do
      create(:template,
            user: user,
            sub_category: sub_category)
    end

    before do
      sign_in user
    end

    it "テンプレートを削除できる" do
      expect do
        delete template_path(template)
      end.to change(Template, :count).by(-1)

      expect(response).to redirect_to(templates_path)
    end
  end
end
