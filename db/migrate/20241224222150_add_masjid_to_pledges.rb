class AddMasjidToPledges < ActiveRecord::Migration[7.0]
  def change
    add_reference :pledges, :masjid, null: false, foreign_key: true
  end
end
