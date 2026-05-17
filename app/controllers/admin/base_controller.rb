module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    private

    def authorize_admin!
      return if current_user.admin?

      redirect_to dashboard_path, alert: '管理者権限が必要です。'
    end
  end
end
