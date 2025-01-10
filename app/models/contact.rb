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

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ["first_name", "last_name", "email", "phone_number", "amount_pledged", "amount_donated"]
      all.each do |contact|
        csv << [contact.first_name, contact.last_name, contact.email, contact.phone_number, "$#{contact.pledges.sum(:amount)}", "$#{contact.donations.sum(:amount)}"]
      end
    end
  end
end
