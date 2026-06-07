class SubCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sub_category, only: %i[edit update destroy]

  def index
    @sub_categories = current_user.sub_categories
                                  .includes(:category)
                                  .order(:id)
  end

  def new
    @sub_category = current_user.sub_categories.new
  end

  def create
    @sub_category = current_user.sub_categories.new(sub_category_params)

    if @sub_category.save
      redirect_to sub_categories_path,
                  notice: "サブカテゴリーを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @sub_category.update(sub_category_params)
      redirect_to sub_categories_path,
                  notice: "サブカテゴリーを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  if @sub_category.transactions.exists?
    redirect_to sub_categories_path,
                alert: "このサブカテゴリーは取引で使用されているため削除できません"
    return
  end

  @sub_category.destroy!

  redirect_to sub_categories_path,
              notice: "サブカテゴリーを削除しました。"
end

  private

  def set_sub_category
    @sub_category = current_user.sub_categories.find(params[:id])
  end

  def sub_category_params
    params.require(:sub_category).permit(:category_id, :name)
  end
end
