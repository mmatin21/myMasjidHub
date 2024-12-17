class Pledge < ApplicationRecord
  belongs_to :fundraiser
  belongs_to :contact, optional: true
  has_many :donations

  accepts_nested_attributes_for :contact, reject_if: :all_blank

  attr_accessor :new_contact_attributes

  before_validation :build_new_contact_if_needed

  private

  def build_new_contact_if_needed
    if new_contact_attributes.present?
      self.contact = Contact.new(new_contact_attributes)
    end
  end
end
