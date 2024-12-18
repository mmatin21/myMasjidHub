class Donation < ApplicationRecord
  belongs_to :fundraiser
  belongs_to :masjid
  belongs_to :contact
  belongs_to :pledge, optional: true

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}

  def self.ransackable_attributes(auth_object = nil) 
    ["created_at", "amount"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["contact"]
  end

end
