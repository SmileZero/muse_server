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

  def get_fav_music_idList
    self.users_marks.where("mark=1").pluck(:music_id)
  end

  def mark(music,mark_value)
    mark_record = self.users_marks.find_by_music_id music.id
    if mark_record == nil
      self.users_marks.create({music_id: music.id, mark:mark_value })
    elsif mark_record.mark != mark_value
      mark_record.update_attribute("mark",mark_value)
    end
  end

  def liked_marks 
    UsersMark.where("user_id = ? and mark = 1", self.id)
  end

  def like(music)
    marks = self.liked_marks
    marks.each do |mark|
      SongGraph.add_edge(mark.music_id, music.id)
    end

    self.mark music,1
  end

  def unmark(music)

    marks = self.liked_marks
    marks.each do |mark|
      SongGraph.add_edge(mark.music_id, music.id)
    end

    self.mark music,0
  end

  def dislike(music)
  	self.mark music,-1
  end

  def User.new_remember_token
    token = SecureRandom.urlsafe_base64
    while User.find_by_remember_token User.encrypt(token)
      token = SecureRandom.urlsafe_base64
    end
    token
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end
