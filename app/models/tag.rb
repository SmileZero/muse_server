class Tag < ActiveRecord::Base
	validates :name, presence:true, uniqueness: true
	has_many :tag_relationship
	has_many :music, through: :tag_relationship
end
