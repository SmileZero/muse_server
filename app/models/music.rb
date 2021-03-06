class Music < ActiveRecord::Base
	validates_presence_of :name, :resource_id, :music_id, :location, :artist_id, :album_id
	has_many :tag_relationship
	has_many :tags, through: :tag_relationship
	belongs_to :artist
	belongs_to :album
	has_many :users_marks

	def tagging(tag)
		self.tag_relationship.create(tag_id:tag.id)
	end
	def untagging(tag)
		self.tag_relationship.find_by_tag_id(tag.id).destroy
	end
end
