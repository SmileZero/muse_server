class CreateMusics < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.string :name
      t.integer :resource_id
      t.integer :music_id
      t.string :location
      t.integer :artist_id
      t.integer :album_id

      t.timestamps
    end
  end
end
