class SessionsController < ApplicationController
  def new
  end

  def create
	  @user = User.find_by_email(params[:session][:email])
	  if @user && @user.password == params[:session][:password]
	    sign_in @user
	    render json:{status:"ok"}
	  else
	    render json:{status:"failed",msg:"email/password incorrect"}
	  end
  end

  def destroy
  	sign_out
    render json:{status:"ok"}
  end
end
