class DashboardController < ApplicationController
  before_action :set_masjid, only: %i[ index ]

  def index
    @expenses = @masjid.expenses
    @revenues = @masjid.revenues
    @current_date = params[:date] ? Date.parse(params[:date]) : Date.current


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

    @events = current_masjid.events
      .where(event_date: @current_date.beginning_of_month..@current_date.end_of_month)
      .order(event_date: :asc)

    @pledges_data = @masjid.pledges.group_by_year_to_date
    @pledge_labels = @pledges_data.values[0].keys
    @pledges = @pledges_data.values[0]
    @donations = @pledges_data.values[1]

    Rails.logger.debug "!!!Donations: #{@pledges_data.values[0].keys}!!!"

    # Group events by date
    @events_by_date = @events.group_by { |event| event.event_date.to_date }

  end

  private

  def set_masjid
    @masjid = Masjid.find_by(id: current_masjid.id)
  end
end



