class DashboardController < ApplicationController
  before_action :authenticate_masjid!
  before_action :set_masjid, only: %i[index]

  def index
    year = params[:year].presence || Time.current.year
    month = params[:month]

    @expenses = @masjid.expenses.by_year(year).by_month(month)
    @revenues = @masjid.revenues.by_year(year).by_month(month)
    @donations = @masjid.donations.by_year(year).by_month(month)

    @current_date = params[:date] ? Date.parse(params[:date]) : Date.current

    @events = current_masjid.events
                            .where(event_date: @current_date.beginning_of_month..@current_date.end_of_month)
                            .order(event_date: :asc)

    # Group events by date
    @events_by_date = @events.group_by { |event| event.event_date.to_date }

    @combined_records = (@revenues + @donations).sort_by do |record|
      [
        record.is_a?(Donation) ? 1 : 0, # Revenues (0) come before Donations (1)
        -(record.is_a?(Revenue) ? record.date : record.created_at).to_time.to_i # Most recent dates first
      ]
    end
  end

  private

  def set_masjid
    @masjid = Masjid.find_by(id: current_masjid.id)
  end
end
