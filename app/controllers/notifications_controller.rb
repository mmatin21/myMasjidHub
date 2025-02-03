class NotificationsController < ApplicationController
  before_action :authenticate_masjid!

  def index
    @notifications = current_masjid.notifications.order(created_at: :desc).limit(6)
  end

  def mark_as_read
    notifications = current_masjid.notifications.where(read_at: nil)
    Rails.logger.info "Notifications number #{notifications.count.positive?}"

    return unless notifications.count.positive?

    notifications.update_all(read_at: Time.now)
  end
end
