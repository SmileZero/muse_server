json.set! :status, "ok"
json.set! :users_mark do
  json.set! :name, @users_mark.id
  json.set! :user_id, @users_mark.user_id
  json.set! :music_id, @users_mark.music_id
  json.set! :mark, @users_mark.mark
end
