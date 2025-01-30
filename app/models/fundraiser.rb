class Fundraiser < ApplicationRecord
  belongs_to :masjid
  has_many :donations
  has_many :pledges

  validates :name, presence: true
  validates :description, presence: true
  validates :goal_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(_auth_object = nil)
    ['name']
  end
end
