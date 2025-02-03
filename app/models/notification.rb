class Notification < ApplicationRecord
  belongs_to :masjid
  belongs_to :donation, optional: true

  # After a new notification is created, broadcast updates to the relevant targets
  after_create_commit do
    # broadcast_replace_to "topbar_notifications_#{masjid.id}", target: 'notification-badge', partial: 'navbar/topbar/notification_badge', locals: {
    #   masjid: masjid
    # }

    broadcast_prepend_to "dropdown_#{masjid.id}", target: 'notification-dropdown-list', partial: 'navbar/topbar/notification_dropdown', locals: {
      notification: self
    }

    broadcast_prepend_to "notifications_#{masjid.id}", target: 'notification-list', partial: 'notifications/notification_index', locals: {
      notifications: self
    }
  end

  scope :unread, -> { where(read_at: nil) }

  def mark_as_read!
    update(read_at: Time.current)
  end
end
