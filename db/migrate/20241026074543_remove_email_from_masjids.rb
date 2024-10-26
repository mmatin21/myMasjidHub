class RemoveEmailFromMasjids < ActiveRecord::Migration[7.0]
  def change
    remove_column :masjids, :email, :string
  end
end
