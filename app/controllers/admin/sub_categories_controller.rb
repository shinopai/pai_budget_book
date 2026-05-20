class Admin::SubCategoriesController < ApplicationController
  def index
  @sub_categories = current_user.sub_categories
                                .includes(:category)
                                .order(:id)
  end
end
