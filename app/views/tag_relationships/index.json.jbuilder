json.array!(@tag_relationships) do |tag_relationship|
  json.extract! tag_relationship, :id, :tag_id, :music_id
  json.url tag_relationship_url(tag_relationship, format: :json)
end
