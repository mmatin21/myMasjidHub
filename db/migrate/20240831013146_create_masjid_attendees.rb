class CreateMasjidAttendees < ActiveRecord::Migration[7.0]
  def change
    create_table :masjid_attendees do |t|
      t.references :attendee, null: false, foreign_key: true
      t.references :masjid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
