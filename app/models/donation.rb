class Donation < ApplicationRecord
  belongs_to :fundraiser
  belongs_to :masjid

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}

  def self.ransackable_attributes(auth_object = nil) 
    ["created_at", "amount", "first_name", "phone_number"]
  end

end
