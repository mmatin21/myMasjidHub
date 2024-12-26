json.extract! contact, :id, :masjid_id, :first_name, :middle_name, :last_name, :email, :phone_number, :created_at, :updated_at
json.url contact_url(contact, format: :json)
