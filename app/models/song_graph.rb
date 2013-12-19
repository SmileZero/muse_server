class SongGraph < ActiveRecord::Base
	belongs_to :from_music, :class_name => "Music"
	belongs_to :to_music, :class_name => "Music"


	class << self
    def add_edge( from_id, to_id )

    	if from_id == to_id
    		return 
    	end

    	song_graph = SongGraph.where(
    		"from_music_id = ? and to_music_id = ?",
    		from_id, to_id)

    	if song_graph.count > 0
    		song_graph[0].song_weight += 1
    		song_graph[0].save
    	else 
    		SongGraph.create(from_music_id: from_id,
    		 to_music_id: to_id,
    		 song_weight: 0)
    	end

    end

    def remove_edge( from_id, to_id )
    	song_graph = SongGraph.where(
    		"from_music_id = ? and to_music_id = ?",
    		from_id, to_id)

    	if song_graph.count > 0
    		song_graph[0].song_weight -= 1
    		song_graph[0].save
    	end
    end
  end
end
