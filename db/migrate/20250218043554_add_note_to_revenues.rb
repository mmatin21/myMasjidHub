class AddNoteToRevenues < ActiveRecord::Migration[7.0]
  def change
    add_column :revenues, :note, :text
  end
end
