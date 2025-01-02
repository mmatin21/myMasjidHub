class DashboardController < ApplicationController
  before_action :set_masjid, only: %i[ index ]

  def index
    @expenses = @masjid.expenses
    @revenues = @masjid.revenues
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
