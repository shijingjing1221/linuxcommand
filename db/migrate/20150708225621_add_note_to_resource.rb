class AddNoteToResource < ActiveRecord::Migration
  def change
    add_column :resources, :note, :text
  end
end
