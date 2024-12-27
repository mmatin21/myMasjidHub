# frozen_string_literal: true

module Types
  class FundraiserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :description, String
    field :goal_amount, Float
    field :masjid_id, Integer, null: false
    field :end_date, GraphQL::Types::ISO8601DateTime
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
