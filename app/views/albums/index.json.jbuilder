json.array!(@albums) do |album|
  json.extract! album, :id, :resource_id, :album_id, :name, :cover_url, :cover_local, :artist_id
  json.url album_url(album, format: :json)
end
