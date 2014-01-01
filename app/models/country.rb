class Country < ActiveRecord::Base
	has_many :artists

	def music
		Music.where("artist_id in (?)",self.artists.pluck("id"))
	end
end
