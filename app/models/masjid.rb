class Masjid < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :expenses
  has_many :revenues
  has_many :masjid_attendees, dependent: :destroy
  has_many :attendees, through: :masjid_attendees
  has_many :fundraisers
  has_many :donations
  has_many :prayers
  has_many :contacts
  has_many :pledges
  has_many :events
  has_many :notifications


  def full_address
    address + " " + city + " " +  state
  end
  

end
