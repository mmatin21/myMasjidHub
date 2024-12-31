# frozen_string_literal: true

module Types
  class EventType < Types::BaseObject
    field :id, ID, null: false
    field :masjid_id, Integer
    field :name, String
    field :description, String
    field :event_date, GraphQL::Types::ISO8601DateTime
    field :address, String
    field :city, String
    field :state, String
    field :zipcode, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :formatted_event_date, String, null: false

    def formatted_event_date
      object.event_date.strftime("%A, %B %e") # Example: "2000-01-01 13:30"
    end
  end
end
