class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @total_assets = current_user.total_assets
  end
end
