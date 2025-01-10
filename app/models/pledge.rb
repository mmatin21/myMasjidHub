class Pledge < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :fundraiser
  belongs_to :contact, optional: true
  has_many :donations
  belongs_to :masjid

  accepts_nested_attributes_for :contact, reject_if: :all_blank

  attr_accessor :new_contact_attributes

  before_validation :build_new_contact_if_needed

  def self.group_by_year_to_date
    start_date = Time.current.beginning_of_year
    end_date = Time.current.end_of_day
  
    # Group pledge amounts by month/year
    pledge_amounts = self.where(created_at: start_date..end_date)
                         .group("TO_CHAR(created_at, 'MM/YYYY')")
                         .sum(:amount)
  
    # Group donation amounts by month/year
    donation_amounts = Donation.where(created_at: start_date..end_date)
                                .joins(:pledge) # Ensure we only consider donations linked to pledges
                                .group("TO_CHAR(donations.created_at, 'MM/YYYY')")
                                .sum(:amount)
  
    { pledges: pledge_amounts, donations: donation_amounts }
  end

  def name
    "#{self.fundraiser.name} - #{number_to_currency(amount)}"
  end

  private

  def build_new_contact_if_needed
    if new_contact_attributes.present?
      self.contact = Contact.new(new_contact_attributes)
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    super + ['created_at', 'amount']
  end

  def self.ransackable_associations(auth_object = nil)
    super + ['contact', 'fundraiser']
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ["Contact Name", "Email", "Fundraiser", "Amount", "Fulfilled Amount"]
      all.each do |pledge|
        csv << [pledge.contact.name, pledge.contact.email, pledge.fundraiser.name, "$#{pledge.amount}", "$#{pledge.donations.sum(:amount)}"]
      end
    end
  end

  def self.import(file, masjid_id)
    CSV.foreach(file.path, headers: true) do |row|
      pledge_data = row.to_hash
      pledge_data["masjid_id"] = masjid_id # Attach the masjid_id
      Rails.logger.info "Pledge data: #{pledge_data}"


      # Find or initialize fundraiser by name and masjid_id
      fundraiser = Fundraiser.find_or_initialize_by(
        name: pledge_data["Fundraiser"],
        masjid_id: masjid_id
      )
      fundraiser.save if fundraiser.new_record?

      # Find or initialize contact by email and masjid_id
      contact = Contact.find_or_initialize_by(
        email: pledge_data["Email"],
        masjid_id: masjid_id
      )
      contact.save if contact.new_record?

      # Clean Pledge data to only include valid attributes
      pledge_data = {
        amount: pledge_data["Amount"].gsub(/[$,]/, '').to_f,
        fundraiser_id: fundraiser.id,
        contact_id: contact.id,
        masjid_id: masjid_id
      }

      Rails.logger.info "Pledge data: #{pledge_data}"

      # Find existing Pledge or initialize a new one
      pledge = find_or_initialize_by(id: pledge_data["id"])
      pledge.update(pledge_data)
      Rails.logger.info "Pledge updated: #{pledge.errors.full_messages}"
    end
  end
end
