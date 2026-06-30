require "rails_helper"

RSpec.describe "Assets", type: :request do
  describe "GET /edit" do
    let(:user) { create(:user) }
    let!(:asset) { create(:asset, user: user, initial_amount: 100_000) }

    before do
      sign_in user
    end

    it "資産編集画面を表示できる" do
      get edit_asset_path

      expect(response).to have_http_status(:ok)
    end
  end
  describe "PATCH /update" do
    let(:user) { create(:user) }
    let!(:asset) do
      create(:asset, user: user, initial_amount: 100_000)
    end

    before do
      sign_in user
    end

    context "有効なパラメータの場合" do
      it "資産を更新できる" do
        patch asset_path, params: {
          asset: {
            initial_amount: 200_000
          }
        }

        expect(response).to redirect_to(dashboard_path)
        expect(asset.reload.initial_amount).to eq(200_000)
      end
    end

    context "無効なパラメータの場合" do
      it "資産を更新できない" do
        patch asset_path, params: {
          asset: {
            initial_amount: -1
          }
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(asset.reload.initial_amount).to eq(100_000)
      end
    end
  end
end
