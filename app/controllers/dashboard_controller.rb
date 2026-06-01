class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # 総資産
    @total_assets = current_user.total_assets

    # 月間収支
    current_month_transactions = current_user.transactions.where(
      transacted_at: Date.current.beginning_of_month..Date.current.end_of_month
    )

    @monthly_income = current_month_transactions.income.sum(:amount)
    @monthly_expense = current_month_transactions.expense.sum(:amount)
    @monthly_balance = @monthly_income - @monthly_expense

    # 最近の取引5件
    @recent_transactions = current_user.transactions
                                   .includes(sub_category: :category)
                                   .order(transacted_at: :desc, created_at: :desc)
                                   .limit(5)
  end
end
