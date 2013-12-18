class Album < ActiveRecord::Base
	validates_presence_of :name, :resource_id, :album_id, :cover_url, :artist_id
	has_many :music
	belongs_to :artist
end
