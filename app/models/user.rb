require 'bcrypt'

class User < ActiveRecord::Base
	mount_uploader :avatar, AvatarUploader
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }, presence:true, uniqueness: true
	validates :name, presence:true
	has_many :users_marks

	include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def like(music)
  	mark_record = self.users_marks.find_by_music_id music.id
  	if mark_record == nil
  		self.users_marks.create({music_id: music.id, mark:1 })
  	elsif mark_record.mark != 1
  		mark_record.update_attribute("mark",1)
  	end
  end

  def dislike(music)
  	mark_record = self.users_marks.find_by_music_id music.id
  	if mark_record == nil
  		self.users_marks.create({music_id: music.id, mark:-1 })
  	elsif mark_record.mark != -1
  		mark_record.update_attribute("mark",-1)
  	end
  end

end
