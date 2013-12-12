class Album < ActiveRecord::Base
	has_many :music
	belongs_to :artist
end
