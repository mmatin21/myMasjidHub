require 'csv'
class Expense < ApplicationRecord

  belongs_to :masjid
  
  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :date, presence: true

  scope :by_year, ->(year) { where('extract(year from date) = ?', year) }
  scope :by_year_and_month, ->(year, month) { where('extract(year from date) = ? AND extract(month from date) = ?', year, month) }


  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ["name", "amount", "date"]
      all.each do |expense|
        csv << [expense.name, expense.amount, expense.date]
      end
    end
  end

  def self.import(file, masjid_id)
    CSV.foreach(file.path, headers: true) do |row|
      expense_data = row.to_hash
      expense_data["masjid_id"] = masjid_id # Attach the masjid_id

      # Find existing expense or initialize a new one
      expense = find_or_initialize_by(id: expense_data["id"]) # Use a unique identifier
      expense.update(expense_data)
    end
  end

  def self.grouped_by_year
    group("extract(year from date)").sum(:amount)
  end

  # Group expenses by year and month
  def self.grouped_by_year_and_month
    group("extract(year from date)", "extract(month from date)").sum(:amount)
  end

  
  def self.group_by_year_to_date
    start_date = Time.current.beginning_of_year
    end_date = Time.current.end_of_day

    # Group donations by month and sum the amount for each month within the current year
    self.where(date: start_date..end_date)
        .group("TO_CHAR(date, 'MM/YYYY')")
        .sum(:amount)
  end

  def self.group_by_last_three_months
    start_date = 2.months.ago.beginning_of_month
    end_date = Time.current.end_of_month

    # Group donations by month and sum the amount for each month, formatting as 'MM/DD/YYYY'
    self.where(date: start_date..end_date)
        .group("TO_CHAR(date, 'MM/YYYY')")
        .sum(:amount)
  end

  def self.ransackable_attributes(auth_object = nil) 
    ["name", "date", "amount"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

end
