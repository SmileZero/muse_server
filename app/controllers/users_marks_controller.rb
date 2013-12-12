class UsersMarksController < ApplicationController
  before_action :set_users_mark, only: [:show, :edit, :update, :destroy]

  # GET /users_marks
  # GET /users_marks.json
  def index
    @users_marks = UsersMark.all
  end

  # GET /users_marks/1
  # GET /users_marks/1.json
  def show
  end

  # GET /users_marks/new
  def new
    @users_mark = UsersMark.new
  end

  # GET /users_marks/1/edit
  def edit
  end

  # POST /users_marks
  # POST /users_marks.json
  def create
    @users_mark = UsersMark.new(users_mark_params)

    respond_to do |format|
      if @users_mark.save
        format.html { redirect_to @users_mark, notice: 'Users mark was successfully created.' }
        format.json { render action: 'show', status: :created, location: @users_mark }
      else
        format.html { render action: 'new' }
        format.json { render json: @users_mark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users_marks/1
  # PATCH/PUT /users_marks/1.json
  def update
    respond_to do |format|
      if @users_mark.update(users_mark_params)
        format.html { redirect_to @users_mark, notice: 'Users mark was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @users_mark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users_marks/1
  # DELETE /users_marks/1.json
  def destroy
    @users_mark.destroy
    respond_to do |format|
      format.html { redirect_to users_marks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users_mark
      @users_mark = UsersMark.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def users_mark_params
      params.require(:users_mark).permit(:user_id, :music_id, :mark)
    end
end
