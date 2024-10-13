class Attendee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :masjid_attendees, dependent: :destroy
  has_many :masjids, through: :masjid_attendees
  has_many :donations


  def self.ransackable_attributes(auth_object = nil) 
    ["name", "email", "phone_number"]
  end

end
