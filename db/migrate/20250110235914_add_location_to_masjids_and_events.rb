class AddLocationToMasjidsAndEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :masjids, :latitude, :float
    add_column :masjids, :longitude, :float
    add_column :events, :latitude, :float
    add_column :events, :longitude, :float
  end
end