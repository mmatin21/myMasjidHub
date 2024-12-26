# frozen_string_literal: true

module Types
  class DonationType < Types::BaseObject
    field :id, ID, null: false
    field :fundraiser_id, Integer, null: false
    field :masjid_id, Integer, null: false
    field :amount, Float
    field :currency, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :first_name, String
    field :last_name, String
    field :email, String
    field :phone_number, String
    field :contact, Types::ContactType, null: true
    field :pledge_id, Integer
  end
end
