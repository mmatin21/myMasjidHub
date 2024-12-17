class Contact < ApplicationRecord
  belongs_to :masjid
  has_many :donations
  has_many :pledges
end
