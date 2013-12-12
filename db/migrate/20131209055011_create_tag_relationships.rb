class CreateTagRelationships < ActiveRecord::Migration
  def change
    create_table :tag_relationships do |t|
      t.integer :tag_id
      t.integer :music_id

      t.timestamps
    end
  end
end
