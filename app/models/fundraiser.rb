class Fundraiser < ApplicationRecord
  belongs_to :masjid
  has_many :donations

  validates :name, presence: true
  validates :description, presence: true
  validates :goal_amount, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :end_date, presence: true


end
