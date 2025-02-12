class AddStripeCustomerIdToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :stripe_customer_id, :string
  end
end
