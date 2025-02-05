class LandingController < ApplicationController
  def index
    return unless masjid_signed_in?

    redirect_to masjid_dashboard_index_path(current_masjid)
  end
end
