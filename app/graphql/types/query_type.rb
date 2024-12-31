# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    field :masjids, [Types::MasjidType], null: false
    field :masjid_by_id, [Types::MasjidType], null: false do
      argument :id, ID, required: false
    end

    field :fundraisers, [Types::FundraiserType], null: true do
      argument :masjid_id, ID, required: true
    end

    field :fundraiser_by_id, [Types::FundraiserType], null: true do
      argument :id, ID, required: true
    end

    field :events, [Types::EventType], null: true do
      argument :masjid_id, ID, required: true
    end

    field :prayers, [Types::PrayerType], null: true do
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
    def masjids
      Masjid.all
    end

    def masjid_by_id(id:)
      Masjid.where(id: id)
    end

    def fundraisers(masjid_id:)
      Fundraiser.where(masjid_id: masjid_id)
    end

    def fundraiser_by_id(id:)
      Fundraiser.where(id: id)
    end

    def donations(fundraiser_id:)
      Donation.where(fundraiser_id: fundraiser_id)
    end

    def contacts(email:)
      Contact.where(email: email)
    end

    def events(masjid_id:)
      Event.where(masjid_id: masjid_id)
    end

    def prayers(masjid_id:)
      Prayer.where(masjid_id: masjid_id)
    end
  end
end
