class TagRelationship < ActiveRecord::Base
	validates_presence_of :music_id, :tag_id
	belongs_to :music
	belongs_to :tag
end
