class CreateDonations < ActiveRecord::Migration[7.0]
  def change
    create_table :donations do |t|
      t.references :attendee, null: false, foreign_key: true
      t.references :fundraiser, null: false, foreign_key: true
      t.references :masjid, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.string :currency

      t.timestamps
    end
  end
end
