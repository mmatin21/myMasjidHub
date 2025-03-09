# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_donation, mutation: Mutations::CreateDonation
    field :create_pledge, mutation: Mutations::CreatePledge
  end
end
