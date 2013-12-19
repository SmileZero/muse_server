require "open-uri"

    def get_date
      "2013-12-12"
    end

    def parse_artist_data(nokogiri_data)
      data =[]
      nokogiri_data.css('.artist > .info > p > strong > a').each do |table_data|
        name = table_data.inner_text
        artist_id = table_data['href'][8..-1]
        tmphash = {name:name, artist_id:artist_id}
        data << tmphash
      end
      data
    end

    def get_music_from_album(album_id)
      puts "album_id: #{album_id}"
      url = "http://www.xiami.com/app/android/album?id=#{album_id}"
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

      songs = json["album"]["songs"]
      return false if songs.nil?
      songs
    end

    def get_xiami_data(artist_id)
      puts "artist_id: #{artist_id}"
      url = "http://www.xiami.com/app/android/artist-topsongs?id=#{artist_id}"
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
      return false if songs.nil?
      songs
    end

    def get_album_data(artist_id)
      puts "artist_id: #{artist_id}"
      url = "http://www.xiami.com/app/android/artist-albums?id=#{artist_id}"
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

      albums = json["albums"]
      return false if albums.nil?
      albums
    end
namespace :muse do 
    desc "get popular artists json"
    task :popular_artists do
      puts "getting popular artists json"
      i = 1
      puts "page: #{i}"
      url = "http://www.xiami.com/artist/index/c/2/type/0/class/0/page/#{i}"
      url = URI.encode(url)

      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)

      page_number = doc.css('.all_page > a').to_a.last(2).first
      max_page_number = page_number.nil? ? 0 : page_number.inner_text.to_i

      first_page_data = parse_artist_data(doc)

      other_page_data = []
      if max_page_number != 0
        for i in 2..max_page_number
          puts "page: #{i}"
          next_page_url = "http://www.xiami.com/artist/index/c/2/type/0/class/0/page/#{i}"
          charset = nil
          html2 = open(next_page_url) do |f|
            charset = f.charset
            f.read
          end
          next_page_doc = Nokogiri::HTML.parse(html2, nil, charset)

          other_page_data += parse_artist_data(next_page_doc)
        end
      end

      output_data = first_page_data + other_page_data

      File.open("public/artists/" + get_date + "_xiami.json", "w") do |f|
        f.write(output_data.to_json)
      end
    end

    desc "add artist into database"
    task :artists_into_DS => :environment do
      puts "adding artist into database"
      File.open("public/artists/" + get_date + "_xiami.json") do |f|
        json = JSON.parse(f.read)
        json.each{|artist|
            if Artist.find_by_artist_id artist["artist_id"].to_i
            else
              puts artist["name"]
              Artist.create({resource_id:0,name:CGI.unescapeHTML(artist["name"]),artist_id:artist["artist_id"]});
            end
        }
      end
    end

    desc "get songs by artist"
    task :artist_topsongs => :environment do
      puts "getting songs by artist"
      artists = Artist.all
      artists.each{|artist|
        output_data = get_xiami_data artist.artist_id
        path = "public/musics/#{artist.artist_id}"
        if !File.exist?(path) 
          Dir.mkdir(path)
        end
        File.open("public/musics/#{artist.artist_id}/" + get_date + "_xiami.json", "w") do |f|
          f.write(output_data.to_json)
        end
      }
    end

    desc "get albums by artist"
    task :artist_albums => :environment do
      puts "gettgin albums by artist"
      artists = Artist.all
      artists.each{|artist|
        output_data = get_album_data artist.artist_id
        path = "public/artists/#{artist.artist_id}/"
        if !File.exist?(path) 
          Dir.mkdir(path)
        end
        File.open("public/artists/#{artist.artist_id}/" + get_date + "_xiami.json", "w") do |f|
          f.write(output_data.to_json)
        end
      }
    end

    desc "add albums into database"
    task :albums_into_DS => :environment do
      puts "adding albums into database"
      artists = Artist.all
      artists.each{|artist|
        File.open("public/artists/#{artist.artist_id}/" + get_date + "_xiami.json") do |f|
          json = JSON.parse f.read
          json.each{|album|
            if !Album.find_by_album_id album["album_id"].to_i
              puts "album: #{album["title"]}"
              album_params = {}
              album_params["resource_id"] = 0
              album_params["album_id"] = album["album_id"].to_i
              album_params["name"] = CGI.unescapeHTML(album["title"])
              album_params["cover_url"] = album["album_logo"][0..-7]+album["album_logo"][-4..-1]
              album_params["artist_id"] = artist.id
              album_record = Album.create(album_params)
            end
          }
        end
      }
    end

    desc "add songs into database"
    task :songs_into_DS => :environment do
      puts "adding songs into database"
      artists = Artist.all
      artists.each{|artist|
        File.open("public/musics/#{artist.artist_id}/" + get_date + "_xiami.json") do |f|
          json = JSON.parse f.read
          json.each{|song|
            if !Music.find_by_music_id song["song_id"].to_i
              puts song["name"]
              music_params = {}
              music_params["name"] = CGI.unescapeHTML(song["name"])
              music_params["resource_id"] = 0
              music_params["music_id"] = song["song_id"].to_i
              music_params["location"] = song["location"]
              music_params["artist_id"] = artist.id
              music_params["lyric"] = song["lyric"]
              album = Album.find_by_album_id song["album_id"]
              if album
                music_params["album_id"] = album.id
              else
                # create new album
                album_params = {}
                #album = get_album_data song["album_id"]
                album_params["resource_id"] = 0
                album_params["album_id"] = song["album_id"].to_i#album["album_id"].to_i
                album_params["name"] = CGI.unescapeHTML(song["title"])#album["title"]

                album_params["cover_url"] = song["album_logo"][0..-7]+song["album_logo"][-4..-1]#album["album_logo"]
                album_params["artist_id"] = artist.id
                album_record = Album.create(album_params)
                music_params["album_id"] = album_record.id
              end
              Music.create music_params
            end
          }
        end
      }
    end

    desc "get songs from albums"
    task :album_songs => :environment do
      puts "getting songs from albums json"
      albums = Album.all
      albums.each{|album|
        output_data = get_music_from_album album.album_id
        path = "public/artists/#{album.artist.artist_id}/albums"
        if !File.exist?(path) 
          Dir.mkdir(path)
        end
        path = "public/artists/#{album.artist.artist_id}/albums/#{album.album_id}"
        if !File.exist?(path) 
          Dir.mkdir(path)
        end
        File.open("public/artists/#{album.artist.artist_id}/albums/#{album.album_id}/" + get_date + "_xiami.json", "w") do |f|
          f.write(output_data.to_json)
        end
      }
    end

    desc "get radio tags json"
    task :radio_tags do
      output_data = get_radio_tags
      path = "public/tags/"
        if !File.exist?(path) 
          Dir.mkdir(path)
        end
        File.open("public/tags/" + get_date + "_xiami.json", "w") do |f|
          f.write(output_data.to_json)
        end
    end

    desc "get radio songs json"
    task :radio_songs do
      File.open("public/tags/" + get_date + "_xiami.json") do |f|
          json = JSON.parse f.read
          json.each{|tag|
            output_data = get_radio_songs tag["radio_id"]
             path = "public/tags/#{tag["radio_id"]}/"
             if !File.exist?(path) 
               Dir.mkdir(path)
             end
             File.open("public/tags/#{tag["radio_id"]}/" + get_date + "_xiami.json", "w") do |f|
               f.write(output_data.to_json)
             end
          }
      end
    end

    desc "radio into database"
    task :radio_into_DS => :environment do
      File.open("public/tags/" + get_date + "_xiami.json") do |f|
        json = JSON.parse f.read
        json.each{|tag_json|
          if tag_json["radio_name"]=="虾米猜"
            next
          end
          puts tag_json["radio_name"]
          tag = Tag.find_by_name tag_json["radio_name"]
          if tag.nil?
            tag = Tag.create({name:tag_json["radio_name"]})
          end
          File.open("public/tags/#{tag_json["radio_id"]}/" + get_date + "_xiami.json") do |f|
            songs_json = JSON.parse f.read

            songs_json.each{|song|
              artist = Artist.find_by_artist_id song["artist_id"].to_i
              if artist
              else
                puts song["artist_name"]
                artist = Artist.create({resource_id:0,name:CGI.unescapeHTML(song["artist_name"]),artist_id:song["artist_id"]});
              end
              music = Music.find_by_music_id song["song_id"].to_i
              if !music
                puts song["name"]
                music_params = {}
                music_params["name"] = CGI.unescapeHTML(song["name"])
                music_params["resource_id"] = 0
                music_params["music_id"] = song["song_id"].to_i
                music_params["location"] = song["location"]
                music_params["artist_id"] = artist.id
                music_params["lyric"] = song["lyric"]
                album = Album.find_by_album_id song["album_id"]
                if album
                  music_params["album_id"] = album.id
                else
                  # create new album
                  album_params = {}
                  #album = get_album_data song["album_id"]
                  album_params["resource_id"] = 0
                  album_params["album_id"] = song["album_id"].to_i#album["album_id"].to_i
                  album_params["name"] = CGI.unescapeHTML(song["title"])#album["title"]

                  album_params["cover_url"] = song["album_logo"][0..-7]+song["album_logo"][-4..-1]#album["album_logo"]
                  album_params["artist_id"] = artist.id
                  album_record = Album.create(album_params)
                  music_params["album_id"] = album_record.id
                end
                music = Music.create music_params
              end
              music.tagged tag
            }

          end
        }
      end
    end


    desc "popular songs' json into database"
    task :popular_into_DS => [:environment,:artists_into_DS,:albums_into_DS,:songs_into_DS] do
    end

    desc "get radio songs' json"
    task :radio_info => [:radio_tags,:radio_songs] do
    end
  end
