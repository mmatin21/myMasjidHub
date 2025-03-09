# frozen_string_literal: true

module Mutations
  class CreatePledge < BaseMutation
    argument :fundraiser_id, ID, required: true
    argument :amount, Float, required: true
    argument :contact_email, String, required: true
    argument :contact_first_name, String, required: true
    argument :contact_last_name, String, required: true

    description 'Creates a new pledge'

    field :pledge, Types::PledgeType, null: true
    field :errors, [String], null: true

    # In app/graphql/mutations/create_pledge.rb
    def resolve(fundraiser_id:, amount:, contact_email:, contact_first_name:, contact_last_name:)
      fundraiser = Fundraiser.find_by(id: fundraiser_id)
      Rails.logger.info "Creating pledge for fundraiser: #{fundraiser_id}"

      return { pledge: nil, errors: ['Fundraiser not found'] } unless fundraiser

      # Find or create contact
      contact = Contact.find_by(email: contact_email, masjid_id: fundraiser.masjid_id) ||
                Contact.new(email: contact_email, masjid_id: fundraiser.masjid_id)

      if contact.new_record?
        contact.first_name = contact_first_name
        contact.last_name = contact_last_name
        return { pledge: nil, errors: contact.errors.full_messages } unless contact.save
      end

      # Create the pledge
      pledge = Pledge.new(
        amount: amount,
        fundraiser_id: fundraiser.id,
        contact_id: contact.id,
        masjid_id: fundraiser.masjid_id
      )

      Rails.logger.info "Attempting to save pledge: #{pledge.attributes}"

      if pledge.save
        Rails.logger.info "Pledge saved successfully: #{pledge.id}"

        # Send confirmation email to the user
        PledgeMailer.confirmation_email(pledge).deliver_now
        Rails.logger.info "Sent confirmation email to #{contact.email}"

        # Create notification for the masjid
        Notification.create!(
          masjid_id: fundraiser.masjid_id,
          message: "#{contact.first_name} #{contact.last_name} has pledged $#{'%.2f' % pledge.amount} to the '#{fundraiser.name}' fundraiser."
          # No donation_id since this is a pledge
        )

        Rails.logger.info "Created notification for masjid #{fundraiser.masjid_id}"

        # Return success response
        { pledge: pledge, errors: [] }
      else
        Rails.logger.error "Pledge save failed: #{pledge.errors.full_messages}"
        { pledge: nil, errors: pledge.errors.full_messages }
      end
    end
  end
end
