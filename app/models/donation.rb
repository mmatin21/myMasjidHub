class Donation < ApplicationRecord
  belongs_to :attendee
  belongs_to :fundraiser
  belongs_to :masjid

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :currency, presence: true
end
