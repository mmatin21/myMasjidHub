require 'csv'

class Donation < ApplicationRecord
  belongs_to :fundraiser
  belongs_to :masjid
  belongs_to :contact
  belongs_to :pledge, optional: true
  has_many :notifications, dependent: :destroy

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :contact, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at amount]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['contact']
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << %w[first_name last_name email fundraiser amount created_at]
      all.each do |donation|
        csv << [donation.contact.first_name, donation.contact.last_name, donation.contact.email,
                donation.fundraiser.name, "$#{donation.amount}", donation.created_at.strftime('%m/%d/%Y')]
      end
    end
  end

  def self.import(file, masjid_id)
    CSV.foreach(file.path, headers: true) do |row|
      donation_data = row.to_hash
      donation_data['masjid_id'] = masjid_id # Attach the masjid_id

      # Find or initialize fundraiser by name and masjid_id
      fundraiser = Fundraiser.find_or_initialize_by(
        name: donation_data['fundraiser'],
        masjid_id: masjid_id
      )
      fundraiser.save if fundraiser.new_record?

      # Find or initialize contact by email and masjid_id
      contact = Contact.find_or_initialize_by(
        email: donation_data['email'],
        masjid_id: masjid_id
      )
      contact.save if contact.new_record?

      # Clean donation data to only include valid attributes
      donation_attributes = {
        amount: donation_data['amount'].gsub(/[$,]/, '').to_f,
        fundraiser_id: fundraiser.id,
        contact_id: contact.id,
        masjid_id: masjid_id
      }

      Rails.logger.info "Donation data: #{donation_attributes}"

      # Find existing donation or initialize a new one
      donation = find_or_initialize_by(id: donation_data['id'])
      donation.update(donation_attributes)
      Rails.logger.info "Donation updated: #{donation.errors.full_messages}"
    end
  end
end
