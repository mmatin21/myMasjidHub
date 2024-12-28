# frozen_string_literal: true

module Types
  class MasjidType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :address, String
    field :city, String
    field :state, String
    field :zipcode, String
    field :phone_number, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :email, String
    field :stripe_account_id, String
  end
end