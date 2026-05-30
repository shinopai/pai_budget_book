module CalendarHelper
  # 日付の配列を返す
  def calendar_dates(date)
    start_date = date.beginning_of_month.beginning_of_week(:sunday)
    end_date = date.end_of_month.end_of_week(:sunday)

    (start_date..end_date).to_a
  end

def daily_income_total(transactions)
  transactions
    .select(&:income?)
    .sum(&:amount)
end

def daily_expense_total(transactions)
  transactions
    .select(&:expense?)
    .sum(&:amount)
end
end
