require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "未ログイン時" do
    it "ダッシュボードへアクセスするとログイン画面へリダイレクトされる" do
      get dashboard_path

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "資産編集画面へアクセスするとログイン画面へリダイレクトされる" do
      get edit_asset_path

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "取引一覧へアクセスするとログイン画面へリダイレクトされる" do
      get transactions_path

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "テンプレート一覧へアクセスするとログイン画面へリダイレクトされる" do
      get templates_path

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "カテゴリー一覧へアクセスするとログイン画面へリダイレクトされる" do
      get categories_path

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "サブカテゴリー一覧へアクセスするとログイン画面へリダイレクトされる" do
      get sub_categories_path

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "管理者ダッシュボードへアクセスするとログイン画面へリダイレクトされる" do
      get admin_path

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "管理者ユーザー一覧へアクセスするとログイン画面へリダイレクトされる" do
      get admin_users_path

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "管理者カテゴリー一覧へアクセスするとログイン画面へリダイレクトされる" do
      get admin_categories_path

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
