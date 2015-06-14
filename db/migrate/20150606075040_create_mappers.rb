class CreateMappers < ActiveRecord::Migration
  def change
    create_table :mappers do |t|
      t.integer :keyword_id
      t.integer :resource_id

      t.timestamps
    end
  end
end
