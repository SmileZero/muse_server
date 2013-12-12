class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :resource_id
      t.integer :album_id
      t.string :name
      t.string :cover_url
      t.string :cover_local
      t.integer :artist_id

      t.timestamps
    end
  end
end
