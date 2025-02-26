class Masjid < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  extend FriendlyId
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
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      %i[name id]
    ]
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def full_address
    "#{address}, #{city} #{state}, #{zipcode}"
  end
end
