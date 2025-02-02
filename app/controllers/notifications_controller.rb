class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[show mark_as_read]

  def index
    @notifications = Notification.where(masjid_id: current_masjid.id).order(created_at: :desc)
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
