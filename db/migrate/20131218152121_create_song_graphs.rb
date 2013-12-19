class CreateSongGraphs < ActiveRecord::Migration
  def change
    create_table :song_graphs do |t|
      t.integer :song_weight
      t.integer :from_music_id
      t.integer :to_music_id

      t.timestamps
    end
  end
end
