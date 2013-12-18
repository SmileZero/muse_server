class Tag < ActiveRecord::Base
	validates :name, presence:true, uniqueness: true
	has_many :tag_relationship
	has_many :music, through: :tag_relationship

	def get_music_idList
		self.music.select("musics.id").pluck(:id)
	end

end
