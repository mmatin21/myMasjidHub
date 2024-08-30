class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.references :masjid, index: true
      t.string :name
      t.decimal :amount, precision: 10, scale: 2
      t.date :expense_date

      t.timestamps
    end
  end
end
