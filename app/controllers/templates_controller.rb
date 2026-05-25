class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_template, only: %i[edit update destroy]

  def index
    @templates = current_user.templates
                             .includes(sub_category: :category)
                             .order(created_at: :desc)
  end

  def new
    @template = current_user.templates.new
  end

  def create
    @template = current_user.templates.new(template_params)

    if @template.save
      redirect_to templates_path, notice: 'テンプレートを登録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @template.update(template_params)
      redirect_to templates_path, notice: 'テンプレートを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @template.destroy

    redirect_to templates_path, notice: 'テンプレートを削除しました。'
  end

  private

  def set_template
    @template = current_user.templates.find(params[:id])
  end

  def template_params
    params.require(:template).permit(
      :sub_category_id,
      :amount,
      :transaction_type,
      :memo
    )
  end
end
