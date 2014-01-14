class MusicsController < ApplicationController
  #before_action :signed_in_user
  before_action :set_music, only: [:edit, :update, :destroy]

  # GET /musics
  # GET /musics.json
  def index
    @musics = Music.all
  end

  # GET /musics/1
  # GET /musics/1.json
  def show
    begin
      @music = Music.find(params[:id])
      users_mark = current_user.users_marks.find_by_music_id params[:id]
      mark = 0
      if users_mark
        mark = users_mark.mark
      end
      artist = @music.artist
      album = @music.album

      cover_url = album.cover_url
      if !([ ".gif", ".jpg", "jpeg", ".png"].include?(cover_url[-4, cover_url.length]))
        cover_url = "not valid picture.1-2-3-4-5-6-7-8-9-0"
      end

      musicInfo = {
        id: @music.id,
        name: @music.name,
        resource_id: 0,
        music_id: @music.music_id,
        location: @music.location,
        lyric: @music.lyric,
        artist_id: artist.artist_id,
        artist_name: artist.name,
        album_id: album.album_id,
        album_name: album.name,
        cover_url: cover_url,
        mark: mark
      }
      @result = {
        status:"ok",
        music: musicInfo
      }
    rescue ActiveRecord::RecordNotFound
      @result = {
        status:"failed",
        msg:"Can't find the music"
      }
    end
  end

  def search
    musicName = params[:musicName]
    artistName = params[:artistName]
    if musicName.nil? || artistName.nil?
      @result = {
          status:"failed",
          msg:"Can't find the music"
      }
      return
    end
    match_musics = Music.joins(:artist).where("musics.name=? AND artists.name = ?",musicName,artistName);
    if match_musics.count == 0
      match_musics = search_song_from_xiami_data musicName,artistName
      if match_musics.nil?
        @result = {
          status:"failed",
          msg:"Can't find the music"
        }
        return
      else
        @music = get_song_from_xiami match_musics[0]["id"]
        if @music.nil?
          @result = {
            status:"failed",
            msg:"Can't find the music"
          }
          return
        end
        artist = Artist.find_by_artist_id @music["artist_id"]
        album = Album.find_by_album_id @music["album_id"]
        if !artist
          artist = Artist.create({artist_id: @music["artist_id"],name: CGI.unescapeHTML(@music["artist_name"]), resource_id: 0})
        end
        if !album
          suffix = @music["album_logo"].rindex "."
          cover_url = @music["album_logo"][0..(suffix-3)]+@music["album_logo"][suffix..-1]
          album = Album.create({resource_id: 0,artist_id: artist.id ,album_id: @music["album_id"], name: CGI.unescapeHTML(@music["title"]), cover_url: cover_url})
        end
        @music = Music.create({music_id: @music["song_id"], resource_id: 0, album_id: album.id, artist_id: artist.id, name: CGI.unescapeHTML(@music["name"]), location: @music["location"], lyric: @music["lyric"]})
        musicInfo = {
          id: @music.id,
          name: @music.name,
          resource_id: 0,
          music_id: @music.music_id,
          location: @music.location,
          lyric: @music.lyric,
          artist_id: artist.artist_id,
          artist_name: artist.name,
          album_id: album.album_id,
          album_name: album.name,
          cover_url: album.cover_url,
          mark: 0
        }
        @result = {
          status:"ok",
          music: musicInfo
        }
      end
    else
      @music =  match_musics[0]
      users_mark = current_user.users_marks.find_by_music_id @music.music_id
      mark = 0
      if users_mark
        mark = users_mark.mark
      end
      artist = @music.artist
      album = @music.album
      musicInfo = {
        id: @music.id,
        name: @music.name,
        resource_id: 0,
        music_id: @music.music_id,
        location: @music.location,
        lyric: @music.lyric,
        artist_id: artist.artist_id,
        artist_name: artist.name,
        album_id: album.album_id,
        album_name: album.name,
        cover_url: album.cover_url,
        mark: mark
      }
      @result = {
        status:"ok",
        music: musicInfo
      }
    end
  end

  # GET /musics/new
  def new
    @music = Music.new
  end

  # GET /musics/1/edit
  def edit
  end

  # POST /musics
  # POST /musics.json
  def create
    @music = Music.new(music_params)

    respond_to do |format|
      if @music.save
        format.html { redirect_to @music, notice: 'Music was successfully created.' }
        format.json { render action: 'show', status: :created, location: @music }
      else
        format.html { render action: 'new' }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /musics/1
  # PATCH/PUT /musics/1.json
  def update
    respond_to do |format|
      if @music.update(music_params)
        format.html { redirect_to @music, notice: 'Music was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /musics/1
  # DELETE /musics/1.json
  def destroy
    @music.destroy
    respond_to do |format|
      format.html { redirect_to musics_url }
      format.json { head :no_content }
    end
  end

  def like
    current_user.like Music.find(params[:id])
    render json:{status:"ok"}
  end

  def dislike
    current_user.dislike Music.find(params[:id])
    render json:{status:"ok"}
  end

  def unmark
    current_user.unmark Music.find(params[:id])
    render json:{status:"ok"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_music
      @music = Music.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def music_params
      params.permit(:musicName, :artistName)
      params.require(:music).permit(:name, :resource_id, :music_id, :location, :artist_id, :album_id)
    end
private
    def search_song_from_xiami_data(musicName,artistName)
      puts "musicName: #{musicName} artistName: #{artistName}"
      url = "http://www.xiami.com/app/android/searchv1?key=#{musicName}%20#{artistName}"
      url = URI.encode(url)
      retries = 20
      begin
        json = JSON.parse(open(url).read)
      rescue
        puts "re"
        retries -= 1
        if retries > 0
          sleep 0.5 and retry
        else
          raise
        end
      end

      songs = json["songs"]
      songs
    end
    def get_song_from_xiami(music_id)
      puts "music_id: #{music_id}"
      url = "http://www.xiami.com/app/iphone/song/id/#{music_id}"
      url = URI.encode(url)
      retries = 20
      begin
        json = JSON.parse(open(url).read)
      rescue
        puts "re"
        retries -= 1
        if retries > 0
          sleep 0.5 and retry
        else
          raise
        end
      end

      song = json
      if song["location"].include? "?auth_key"
        location = song["location"]
        sub_index = location.index "?auth_key"
        song["location"] = location.gsub("m5.","m1.")[0..(sub_index-1)]
      end
      song
    end
end
