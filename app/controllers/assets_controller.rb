class AssetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_asset

  def edit; end

  def update
    if @asset.update(asset_params)
      redirect_to dashboard_path, notice: "資産情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_asset
    @asset = current_user.asset || current_user.build_asset
  end

  def asset_params
    params.require(:asset).permit(:initial_amount)
  end
end
