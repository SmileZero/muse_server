# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Artist.delete_all
artist = Artist.create({resource_id:0,artist_id:57495,name:"Kalafina"})
Album.delete_all
album = Album.create({resource_id:0,album_id:320150,name:"Seventh Heaven",cover_url:"http://img.xiami.net/images/album/img95/57495/3201501310526104_3.jpg",cover_local:"",artist_id:artist.id})
Music.delete_all
music = Music.create({name:"fairytale",resource_id:0,music_id:3559586,location:"http://m1.file.xiami.com/495/57495/320150/3559586_1721802_l.mp3",artist_id:artist.id,album_id:album.id})
Tag.delete_all
tag = Tag.create(name:"animate")
music.tagging tag
