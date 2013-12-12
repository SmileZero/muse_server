class Artist < ActiveRecord::Base
	has_many :music
	has_many :albums
end
