# frozen_string_literal: true

module Types
  class PledgeType < Types::BaseObject
    field :id, ID, null: false
    field :fundraiser_id, Integer, null: false
    field :contact_id, Integer, null: false
    field :amount, Float, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :contact, Types::ContactType, null: true
  end
end
