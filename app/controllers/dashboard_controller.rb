class DashboardController < ApplicationController
  before_action :set_masjid, only: %i[ index ]

  def index
    @expenses = @masjid.expenses
    @revenues = @masjid.revenues

    if params[:view] == "last_three_months"
      @bar_revenues =  @revenues.group_by_last_three_months
      @bar_expenses =  @expenses.group_by_last_three_months
    else
      @bar_expenses =  @expenses.group_by_year_to_date
      @bar_revenues =  @revenues.group_by_year_to_date
    end

    @labels ||= @bar_revenues.keys
    @revenue_series ||= @bar_revenues.values
    @expense_series ||= @bar_expenses.values

    @profit = @revenue_series.sum - @expense_series.sum
    @profit_rate = (@profit / @revenue_series.sum) * 100

    Rails.logger.debug "!!!expenses: #{@pie_expenses.inspect}!!!"

    @events = @masjid.events
    @pledges = @masjid.pledges
    @donations = 0
    @pledges.each do |pledge|
      @donations += pledge.donations.sum(:amount)
    end
  end

  private

  def set_masjid
    @masjid = Masjid.find_by(id: current_masjid.id)
  end
end
