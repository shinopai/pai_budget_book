class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @total_assets = current_user.asset&.initial_amount || 0
  end
end
