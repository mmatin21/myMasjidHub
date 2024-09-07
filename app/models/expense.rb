class Expense < ApplicationRecord
  belongs_to :masjid
  
  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :expense_date, presence: true
  
  scope :by_year, ->(year) { where('extract(year from expense_date) = ?', year) }
  scope :by_year_and_month, ->(year, month) { where('extract(year from expense_date) = ? AND extract(month from expense_date) = ?', year, month) }

  def self.grouped_by_year
    group("extract(year from expense_date)").sum(:amount)
  end

  # Group expenses by year and month
  def self.grouped_by_year_and_month
    group("extract(year from expense_date)", "extract(month from expense_date)").sum(:amount)
  end

  
  def self.grouped_year_to_date
    current_year = Date.today.year
    start_date = Date.new(current_year, 1, 1)
    end_date = Date.today
    where(expense_date: start_date..end_date).sum(:amount)
  end
  
end
