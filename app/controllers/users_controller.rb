class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @result = {
        status:"ok",
        user: @user
      }
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.password = user_params[:password_hash]

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: {status:"ok", user:@user} }
      else
        format.html { render action: 'new' }
        format.json { render json: {status:"failed", msg:@user.errors.full_messages.join("\n")} }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def forgot_password
    @user = User.find_by_email(user_params[:email])
    if @user
      random_password = Array.new(10).map { (65 + rand(58)).chr }.join
      @user.password = random_password
      if @user.save
        UserMailer.create_and_deliver_password_change(@user, random_password).deliver
        render json:{status:"ok"}
      else
        render json:{status:"failed",msg:"Password reset failed"}
      end
    else
      render json:{status:"failed",msg:"Can't find the email"}
    end
  end

  def update_password
    @user = User.find_by_email(user_params[:email]) #params[:old_pwd] params[:new_pwd]
    if @user && @user.password == user_params[:old_pwd]
      @user.password = user_params[:new_pwd]
      if @user.save
        render json:{status:"ok"}
      else
        render json:{status:"failed",msg:"new password can not be updated"}
      end
    else
      render json:{status:"failed",msg:"email/password is incorrect"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password_hash, :name, :avatar, :resource_id ,:old_pwd, :new_pwd)
    end

    def correct_user
      @user = User.find(params[:id])
      render json:{status:"failed", msg:"You have no permission!"} unless current_user?(@user)
    end
end
