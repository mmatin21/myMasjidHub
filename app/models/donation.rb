class Donation < ApplicationRecord
  belongs_to :attendee
  belongs_to :fundraiser
  belongs_to :masjid
end
