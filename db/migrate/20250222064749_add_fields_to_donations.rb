class AddFieldsToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :payment_method, :string
    add_column :donations, :donation_type, :string
    add_column :donations, :mymasjidhub_donation, :boolean
  end
end
