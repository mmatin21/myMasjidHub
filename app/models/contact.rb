class Contact < ApplicationRecord
  belongs_to :masjid
  has_many :donations
  has_many :pledges

  def full_name
    "#{first_name} #{last_name} #{middle_name} (#{email})"
  end
end
