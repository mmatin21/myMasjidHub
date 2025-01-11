class DashboardController < ApplicationController
  before_action :set_masjid, only: %i[ index ]

  def index
    @expenses = @masjid.expenses
    @revenues = @masjid.revenues
    @current_date = params[:date] ? Date.parse(params[:date]) : Date.current

    case params[:view]
    when "last_three_months"
      start_date = 3.months.ago.beginning_of_month
      end_date = Date.current.end_of_month
    when "current_month"
      start_date = Date.current.beginning_of_month
      end_date = Date.current.end_of_month
    else # "ytd"
      start_date = Date.current.beginning_of_year
      end_date = Date.current.end_of_month
    end

    @bar_revenues =  @revenues.group_by_last_three_months
    @bar_expenses =  @expenses.group_by_last_three_months

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

    @combined_records = (Revenue.all + Donation.all).sort_by { |record| 
      [
        record.is_a?(Donation) ? 1 : 0,  # Revenues (0) come before Donations (1)
        -(record.is_a?(Revenue) ? record.date : record.donation_date).to_time.to_i  # Most recent dates first
      ]
    }

  end

  private

  def set_masjid
    @masjid = Masjid.find_by(id: current_masjid.id)
  end
end