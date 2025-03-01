class AddNewFieldsToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :stripe_invoice_id, :string
    add_column :donations, :status, :string
  end
end
