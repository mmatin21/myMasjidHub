class AddSlugToMasjids < ActiveRecord::Migration[7.0]
  def change
    add_column :masjids, :slug, :string
    add_index :masjids, :slug, unique: true
  end
end
