class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :masjid, null: false, foreign_key: true
      t.references :donation, null: false, foreign_key: true
      t.string :message
      t.datetime :read_at

      t.timestamps
    end
  end
end
