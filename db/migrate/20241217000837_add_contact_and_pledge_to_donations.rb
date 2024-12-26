class AddContactAndPledgeToDonations < ActiveRecord::Migration[7.0]
  def change
    add_reference :donations, :contact, null: true, foreign_key: true
    add_reference :donations, :pledge, null: true, foreign_key: true
  end
end
