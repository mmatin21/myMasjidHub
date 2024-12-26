# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    field :masjids, [Types::MasjidType], null: false
    field :fundraisers, [Types::FundraiserType], null: true do
      argument :masjid_id, ID, required: true
    end
    field :donations, [Types::DonationType], null: true do
      argument :fundraiser_id, ID, required: true
    end
    field :contacts, [Types::ContactType], null: true do
      argument :email, String, required: true
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    def masjids
      Masjid.all
    end

    def fundraisers(masjid_id:)
      Fundraiser.where(masjid_id: masjid_id)
    end

    def donations(fundraiser_id:)
      Donation.where(fundraiser_id: fundraiser_id)
    end

    def contacts(email:)
      Contact.where(email: email)
    end

  end
end
