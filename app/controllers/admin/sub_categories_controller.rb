class Admin::SubCategoriesController < ApplicationController
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
    redirect_to admin_sub_categories_path,
                notice: "サブカテゴリーを作成しました。"
  else
    render :new, status: :unprocessable_entity
  end
end

def edit
  @sub_category = current_user.sub_categories.find(params[:id])
end

def update
  @sub_category = current_user.sub_categories.find(params[:id])

  if @sub_category.update(sub_category_params)
    redirect_to admin_sub_categories_path,
                notice: "サブカテゴリーを更新しました。"
  else
    render :edit, status: :unprocessable_entity
  end
end

def destroy
  @sub_category = current_user.sub_categories.find(params[:id])
  @sub_category.destroy!

  redirect_to admin_sub_categories_path,
              notice: "サブカテゴリーを削除しました。"
end

private

def sub_category_params
  params.require(:sub_category).permit(:category_id, :name)
end
end
