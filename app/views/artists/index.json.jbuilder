json.array!(@artists) do |artist|
  json.extract! artist, :id, :resource_id, :artist_id, :name
  json.url artist_url(artist, format: :json)
end
