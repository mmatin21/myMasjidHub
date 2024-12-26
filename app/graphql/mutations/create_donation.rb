# frozen_string_literal: true

module Mutations
  class CreateDonation < BaseMutation
    argument :fundraiser_id, ID, required: true
    argument :amount, Float, required: true
    argument :contact_id, ID, required: true

    description "Creates a new donation"

    field :donation, Types::DonationType, null: false
    field :errors, [String], null: false

    def resolve(fundraiser_id:, amount:, contact_id:)

      fundraiser = Fundraiser.find_by(id: fundraiser_id)
      return { donation:nil, errors: ["Fundraiser not found"] } unless fundraiser


      donation = fundraiser.donations.build(amount: amount, contact_id: contact_id, masjid_id: fundraiser.masjid_id)
      raise GraphQL::ExecutionError.new "Error creating donation", extensions: donation.errors.to_hash unless donation.save
      { donation: donation }
    end
  end
end
