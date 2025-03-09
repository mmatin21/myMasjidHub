# frozen_string_literal: true

module Mutations
  class CreateDonation < BaseMutation
    argument :fundraiser_id, ID, required: true
    argument :amount, Float, required: true
    argument :contact_email, String, required: true
    argument :contact_phone_number, String, required: true
    argument :contact_first_name, String, required: true
    argument :contact_last_name, String, required: true

    description 'Creates a new donation'

    field :donation, Types::DonationType, null: false
    field :errors, [String], null: false

    def resolve(fundraiser_id:, amount:, contact_email:, contact_phone_number:, contact_last_name:, contact_first_name:)
      fundraiser = Fundraiser.find_by(id: fundraiser_id)
      return { donation: nil, errors: ['Fundraiser not found'] } unless fundraiser

      contact = Contact.find_by(email: contact_email) || Contact.new(email: contact_email)
      if contact.new_record?
        contact.first_name = contact_first_name
        contact.last_name = contact_last_name
        contact.phone_number = contact_phone_number
        contact.masjid_id = fundraiser.masjid_id
        return { donation: nil, errors: contact.errors.full_messages } unless contact.save
      end

      donation = fundraiser.donations.build(amount: amount, contact_id: contact.id, masjid_id: fundraiser.masjid_id)
      unless donation.save
        raise GraphQL::ExecutionError.new 'Error creating donation',
                                          extensions: donation.errors.to_hash
      end

      { donation: donation }
    end
  end
end
