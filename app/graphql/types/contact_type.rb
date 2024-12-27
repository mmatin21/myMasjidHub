# frozen_string_literal: true

module Types
  class ContactType < Types::BaseObject
    field :id, ID, null: false
    field :masjid_id, Integer, null: false
    field :first_name, String
    field :middle_name, String
    field :last_name, String
    field :email, String
    field :phone_number, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
