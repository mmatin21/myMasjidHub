class AddStripeAccountIdToMasjids < ActiveRecord::Migration[7.0]
  def change
    add_column :masjids, :stripe_account_id, :string
  end
end
