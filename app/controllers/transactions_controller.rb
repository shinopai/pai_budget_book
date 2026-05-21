class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[edit update destroy]

  def index
    @transactions = current_user.transactions
                                .includes(sub_category: :category)
                                .order(transacted_at: :desc)
  end

  def new
    @transaction = current_user.transactions.new(
      transacted_at: Date.current
    )
  end

  def create
    @transaction = current_user.transactions.new(transaction_params)

    if @transaction.save
      redirect_to transactions_path, notice: '取引を登録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to transactions_path, notice: '取引を更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy

    redirect_to transactions_path, notice: '取引を削除しました。'
  end

  private

  def set_transaction
    @transaction = current_user.transactions.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(
      :sub_category_id,
      :amount,
      :transaction_type,
      :transacted_at,
      :memo
    )
  end
end
