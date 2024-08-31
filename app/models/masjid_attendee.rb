class MasjidAttendee < ApplicationRecord
  belongs_to :attendee
  belongs_to :masjid
end
