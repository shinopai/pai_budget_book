module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: %i[edit update destroy]

    def index
      @categories = current_user.categories.order(:id)
    end

    def new
      @category = current_user.categories.new
    end

    def create
      @category = current_user.categories.new(category_params)

      if @category.save
        redirect_to admin_categories_path, notice: "カテゴリーを作成しました。"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "カテゴリーを更新しました。"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy!
      redirect_to admin_categories_path, notice: "カテゴリーを削除しました。"
    end

    private

    def set_category
      @category = current_user.categories.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
  end
end
