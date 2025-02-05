class NotificationsController < ApplicationController
  before_action :authenticate_masjid!

  def index
    @notifications = current_masjid.notifications.order(created_at: :desc)
  end

  def mark_as_read
    notifications = current_masjid.notifications.where(read_at: nil)

    return unless notifications.count.positive?

    notifications.update_all(read_at: Time.now)
  end
end
