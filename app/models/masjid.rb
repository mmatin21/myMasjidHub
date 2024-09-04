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

  validates :email, presence: true
  validates :phone_number, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true

end
