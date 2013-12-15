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
    render json:{status:"ok"}
  end

  def getCSRFToken
  end

end
