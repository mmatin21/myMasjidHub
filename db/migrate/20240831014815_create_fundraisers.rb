class CreateFundraisers < ActiveRecord::Migration[7.0]
  def change
    create_table :fundraisers do |t|
      t.string :name
      t.text :description
      t.decimal :goal_amount, precision: 10, scale: 2
      t.references :masjid, null: false, foreign_key: true
      t.datetime :end_date

      t.timestamps
    end
  end
end
