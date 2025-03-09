class AllowNullableDonationInNotifications < ActiveRecord::Migration[7.0]
  def change
    change_column_null :notifications, :donation_id, true
    remove_foreign_key :notifications, :donations
  end
end
