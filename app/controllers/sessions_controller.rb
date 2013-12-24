class SessionsController < ApplicationController
  def new
  end

  def create
    remember_token = params[:session][:remember_token]
    if remember_token
      @user = User.find_by_remember_token(remember_token)
      if @user
	      sign_in @user
	      render json:{status:"ok", user: @user}
	    else
	    	render json:{status:"failed",msg:"remember_token is incorrent"}
	    end
    elsif params[:session][:resource_id]
      @user = User.find_by_email(params[:session][:email])
      if @user && @user.password == params[:session][:password] && @user.resource_id == params[:session][:resource_id]
        sign_in @user
        render json:{status:"ok", user: @user}
      else
        render json:{status:"failed",msg:"facebook sign in failed"}
      end
    else
  	  @user = User.find_by_email(params[:session][:email])
  	  if @user && @user.password == params[:session][:password]
  	    sign_in @user
  	    render json:{status:"ok", user: @user}
  	  else
  	    render json:{status:"failed",msg:"email/password incorrect"}
  	  end
    end
  end

  def destroy
  	sign_out
    respond_to do |format|
      format.json { render json: {status:"ok"} }
    end
  end

  def getCSRFToken
  end

end
