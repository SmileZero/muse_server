# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131224075818) do

  create_table "albums", force: true do |t|
    t.integer  "resource_id"
    t.integer  "album_id"
    t.string   "name"
    t.string   "cover_url"
    t.string   "cover_local"
    t.integer  "artist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "artists", force: true do |t|
    t.integer  "resource_id"
    t.integer  "artist_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "musics", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.integer  "music_id"
    t.string   "location"
    t.integer  "artist_id"
    t.integer  "album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lyric"
  end

  create_table "song_graphs", force: true do |t|
    t.integer  "song_weight"
    t.integer  "from_music_id"
    t.integer  "to_music_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_relationships", force: true do |t|
    t.integer  "tag_id"
    t.integer  "music_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "name"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.integer  "resource_id",    default: 0
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "users_marks", force: true do |t|
    t.integer  "user_id"
    t.integer  "music_id"
    t.integer  "mark",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
