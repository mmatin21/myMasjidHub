class RemoveAttendeeFromDonations < ActiveRecord::Migration[7.0]
  def change
    remove_reference :donations, :attendee, null: false, foreign_key: true
    add_column :donations, :first_name, :string
    add_column :donations, :last_name, :string
    add_column :donations, :email, :string
    add_column :donations, :phone_number, :string
  end
end
