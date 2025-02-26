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
    field :formatted_end_date, String, null: false
    field :total_raised_amount, Float, null: false
    field :masjid_name, String, null: false
    field :slug, String, null: false

    def formatted_end_date
      object.end_date.strftime("%A, %B %e") # Example: "2000-01-01 13:30"
    end

    def total_raised_amount
      object.donations.sum(:amount) # Sum all donations linked to this fundraiser
    end

    def masjid_name
      object.masjid.name
    end
  end
end
