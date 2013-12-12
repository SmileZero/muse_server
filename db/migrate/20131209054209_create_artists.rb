class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.integer :resource_id
      t.integer :artist_id
      t.string :name

      t.timestamps
    end
  end
end
