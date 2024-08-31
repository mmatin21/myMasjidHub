class Fundraiser < ApplicationRecord
  belongs_to :masjid
  has_many :donations
end
