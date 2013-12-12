class AddLyricToMusics < ActiveRecord::Migration
  def change
    add_column :musics, :lyric, :string
  end
end
