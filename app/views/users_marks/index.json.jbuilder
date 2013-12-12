json.array!(@users_marks) do |users_mark|
  json.extract! users_mark, :id, :user_id, :music_id, :mark
  json.url users_mark_url(users_mark, format: :json)
end
