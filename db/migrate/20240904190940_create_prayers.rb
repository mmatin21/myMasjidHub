class CreatePrayers < ActiveRecord::Migration[7.0]
  def change
    create_table :prayers do |t|
      t.references :masjid, null: false, foreign_key: true
      t.string :name
      t.time :adhaan
      t.time :iqaamah

      t.timestamps
    end
  end
end
