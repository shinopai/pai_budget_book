require "rails_helper"

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, :admin) }
  let!(:user) { create(:user, name: "パイ") }

  before do
    sign_in admin
  end

  describe "GET /index" do
    it "ユーザー一覧を表示できる" do
      get admin_users_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("パイ")
    end
  end

  describe "GET /show" do
    it "ユーザー詳細を表示できる" do
      get admin_user_path(user)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("パイ")
    end
  end
end
