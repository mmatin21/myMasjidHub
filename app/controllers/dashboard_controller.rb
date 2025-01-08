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
    if @revenue_series.sum > 0
      @profit_rate = (@profit / @revenue_series.sum) * 100
    else
      @profit_rate = 0
    end

    Rails.logger.debug "!!!expenses: #{@pie_expenses.inspect}!!!"

    @events = @masjid.events
    @pledges_data = @masjid.pledges.group_by_year_to_date
    @pledge_labels = @pledges_data.values[0].keys
    @pledges = @pledges_data.values[0]
    @donations = @pledges_data.values[1]

    Rails.logger.debug "!!!Donations: #{@pledges_data.values[0].keys}!!!"
  end

  private

  def set_masjid
    @masjid = Masjid.find_by(id: current_masjid.id)
  end
end
