class Contact < ApplicationRecord
  belongs_to :masjid
  has_many :donations
  has_many :pledges

  def full_name
    "#{first_name} #{last_name} #{middle_name} (#{email})"
  end

  def name
    "#{first_name} #{middle_name} #{last_name}"
  end

  def self.ransackable_attributes(auth_object = nil) 
    ["first_name", "last_name", "email", "phone_number"]
  end
end
