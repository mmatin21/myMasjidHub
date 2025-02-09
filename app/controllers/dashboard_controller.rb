class DashboardController < ApplicationController
  before_action :authenticate_masjid!
  before_action :set_masjid, only: %i[index]

  def index
    @expenses = @masjid.expenses
    @revenues = @masjid.revenues
    @current_date = params[:date] ? Date.parse(params[:date]) : Date.current

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

    @combined_records = (@masjid.reveunes + @masjid.donations).sort_by do |record|
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
