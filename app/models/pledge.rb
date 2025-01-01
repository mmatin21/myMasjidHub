class Pledge < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :fundraiser
  belongs_to :contact, optional: true
  has_many :donations
  belongs_to :masjid

  accepts_nested_attributes_for :contact, reject_if: :all_blank

  attr_accessor :new_contact_attributes

  before_validation :build_new_contact_if_needed

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
end
