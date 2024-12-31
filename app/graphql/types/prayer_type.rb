# frozen_string_literal: true

module Types
  class PrayerType < Types::BaseObject
    field :id, ID, null: false
    field :masjid_id, Integer, null: false
    field :name, String
    field :adhaan, GraphQL::Types::ISO8601DateTime
    field :iqaamah, GraphQL::Types::ISO8601DateTime
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
