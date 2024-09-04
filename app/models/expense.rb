class Expense < ApplicationRecord
  belongs_to :masjid
  
  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :expense_date, presence: true
  
  
end
