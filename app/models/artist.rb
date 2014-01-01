class Artist < ActiveRecord::Base
	validates_presence_of :name, :resource_id, :artist_id
	has_many :music
	has_many :albums
	belongs_to :country

	def set_country(country_name)
		country_record = Country.find_by_name country_name
		if country_record
			self.country_id = country_record.id
			self.save!
		end
	end
	
end
