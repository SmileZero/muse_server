module SessionsHelper
	def sign_in(user)
    remember_token = User.new_remember_token
    session[:remember_token] = remember_token
    user.update_columns(remember_token: User.encrypt(remember_token))
    self.current_user = user
  end
  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    #@current_user   = User.first
    remember_token = User.encrypt(session[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    self.current_user = nil
    session[:remember_token] = nil
  end

  def signed_in_user
    unless signed_in?
      render json:{status:"failed",msg:"Please sign in"}
    end
  end
end
