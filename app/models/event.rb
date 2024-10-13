class Event < ApplicationRecord

  validates :name, presence: true
  validates :description, presence: true
  validates :event_date, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true

  def full_address
  address + " " + city + " " +  state + " " +  zipcode
  end
end
