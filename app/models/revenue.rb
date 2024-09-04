class Revenue < ApplicationRecord
  belongs_to :masjid

  validates :name, presence: true
  validates :amount, prescence: true, numericality: { greater_than_or_equal_to: 0}
  validates :revenue_date, prescence: true

end
