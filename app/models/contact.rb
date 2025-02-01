class Contact < ApplicationRecord
  belongs_to :masjid
  has_many :donations
  has_many :pledges

  before_validation :check_duplicate_email

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  def full_name
    "#{first_name} #{last_name} #{middle_name} (#{email})"
  end

  def name
    "#{first_name} #{middle_name} #{last_name}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[first_name last_name email phone_number]
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << %w[first_name last_name email phone_number amount_pledged amount_donated]
      all.each do |contact|
        csv << [contact.first_name, contact.last_name, contact.email, contact.phone_number,
                "$#{contact.pledges.sum(:amount)}", "$#{contact.donations.sum(:amount)}"]
      end
    end
  end

  def self.import(file, masjid_id)
    CSV.foreach(file.path, headers: true) do |row|
      contact_data = row.to_hash
      contact_data['masjid_id'] = masjid_id # Attach the masjid_id

      # Find existing expense or initialize a new one
      contact = find_or_initialize_by(id: contact_data['id']) # Use a unique identifier
      contact.update(contact_data)
    end
  end

  private

  def check_duplicate_email
    return unless Contact.exists?(masjid_id: masjid_id, email: email)

    errors.add(:email, 'is already associated with a contact in this masjid.')
  end
end
