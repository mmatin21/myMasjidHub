class Notification < ApplicationRecord
  belongs_to :masjid
  belongs_to :donation, optional: true

  scope :unread, -> { where(read_at: nil) }

  def mark_as_read!
    update(read_at: Time.current)
  end
end
