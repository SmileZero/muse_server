class Artist < ActiveRecord::Base
	validates_presence_of :name, :resource_id, :artist_id
	has_many :music
	has_many :albums
end
