class AddActiveToFundraisers < ActiveRecord::Migration[7.0]
  def change
    add_column :fundraisers, :active, :boolean, default: true
  end
end
