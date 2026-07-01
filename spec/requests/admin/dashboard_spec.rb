require "rails_helper"

RSpec.describe "Admin::Dashboard", type: :request do
  describe "GET /admin" do
    let(:admin) { create(:user, :admin) }
    let(:user) { create(:user) }

    context "管理者の場合" do
      before { sign_in admin }

      it "管理画面を表示できる" do
        get admin_path

        expect(response).to have_http_status(:ok)
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in user }

      it "ダッシュボードへリダイレクトする" do
        get admin_path

        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
