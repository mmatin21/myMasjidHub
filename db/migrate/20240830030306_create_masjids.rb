class CreateMasjids < ActiveRecord::Migration[7.0]
  def change
    create_table :masjids do |t|
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :email
      t.string :phone_number
      
      t.timestamps
    end
  end
end
