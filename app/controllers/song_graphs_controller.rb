class SongGraphsController < ApplicationController
  before_action :set_song_graph, only: [:show, :edit, :update, :destroy]

  # GET /song_graphs
  # GET /song_graphs.json
  def index
    liked_music = UsersMark.where("user_id = ? and mark = 1", current_user.id)

    recemond_music = nil

    liked_music.each do |mark|

      finded_music = SongGraph.where(
        "from_music_id = ? and to_music_id not in (select id from users_marks where user_id = ? and mark = 1)", 
        mark.music_id, current_user.id).order("song_weight desc").limit(1)

      if finded_music.count != 0
        recemond_music = finded_music[0]
        break
      end
      
    end 

    result = { status:"none" }

    if recemond_music != nil
      result = { status:"ok", music_id: recemond_music.to_music_id }
    end


    respond_to do |format|
      format.json { render json: result }
    end
  end

  # GET /song_graphs/1
  # GET /song_graphs/1.json
  def show
  end

  # GET /song_graphs/new
  def new
    @song_graph = SongGraph.new
  end

  # GET /song_graphs/1/edit
  def edit
  end

  # POST /song_graphs
  # POST /song_graphs.json
  def create
    @song_graph = SongGraph.new(song_graph_params)

    respond_to do |format|
      if @song_graph.save
        format.html { redirect_to @song_graph, notice: 'Song graph was successfully created.' }
        format.json { render action: 'show', status: :created, location: @song_graph }
      else
        format.html { render action: 'new' }
        format.json { render json: @song_graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /song_graphs/1
  # PATCH/PUT /song_graphs/1.json
  def update
    respond_to do |format|
      if @song_graph.update(song_graph_params)
        format.html { redirect_to @song_graph, notice: 'Song graph was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @song_graph.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /song_graphs/1
  # DELETE /song_graphs/1.json
  def destroy
    @song_graph.destroy
    respond_to do |format|
      format.html { redirect_to song_graphs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song_graph
      @song_graph = SongGraph.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_graph_params
      params.require(:song_graph).permit(:song_weight, :from_music_id, :to_music_id)
    end
end
