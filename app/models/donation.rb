class Donation < ApplicationRecord
  belongs_to :attendee
  belongs_to :fundraiser
  belongs_to :masjid

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}

  def self.ransackable_attributes(auth_object = nil) 
    ["created_at", "amount"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["attendee"]
  end
end
