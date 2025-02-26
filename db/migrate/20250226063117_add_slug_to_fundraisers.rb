class AddSlugToFundraisers < ActiveRecord::Migration[7.0]
  def change
    add_column :fundraisers, :slug, :string
    add_index :fundraisers, :slug, unique: true
  end
end
