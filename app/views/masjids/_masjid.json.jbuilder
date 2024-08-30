json.extract! masjid, :id, :name, :address, :city, :state, :zipcode, :email, :phone_number, :created_at, :updated_at
json.url masjid_url(masjid, format: :json)
