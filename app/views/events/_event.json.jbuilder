json.extract! event, :id, :name, :description, :event_date, :address, :city, :state, :zipcode, :created_at, :updated_at
json.url event_url(event, format: :json)
