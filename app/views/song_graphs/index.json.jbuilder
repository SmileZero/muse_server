json.array!(@song_graphs) do |song_graph|
  json.extract! song_graph, :id, :song_weight, :from_music_id, :to_music_id
  json.url song_graph_url(song_graph, format: :json)
end
