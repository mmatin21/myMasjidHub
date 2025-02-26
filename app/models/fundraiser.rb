require 'rqrcode'
class Fundraiser < ApplicationRecord
  extend FriendlyId

  belongs_to :masjid
  has_many :donations, dependent: :restrict_with_error
  has_many :pledges, dependent: :restrict_with_error
  has_one_attached :qr_code

  after_create :generate_qr_code
  after_destroy :delete_qr_code_from_s3

  validates :name, presence: true
  validates :description, presence: true
  validates :goal_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      %i[name id]
    ]
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
  
  def self.ransackable_attributes(_auth_object = nil)
    ['name']
  end

  private

  def generate_qr_code
    fundraiser_url = "https://mymasjidfinder.onrender.com//masjids/#{masjid_id}/fundraisers/#{id}"
    qr = RQRCode::QRCode.new(fundraiser_url)

    qr_png = StringIO.new(qr.as_png(size: 300, border_modules: 2).to_s)

    qr_code.attach(
      io: qr_png,
      filename: "fundraiser-#{name}.png",
      content_type: 'image/png'
    )
  end

  def delete_qr_code_from_s3
    # Only delete if qr_code is attached
    qr_code.purge_later if qr_code.attached?
  end
end
