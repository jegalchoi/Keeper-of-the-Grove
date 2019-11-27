class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :login!, :logout!, :logged_in?, :current_user_id, :current_user_username

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login!(user)
    @current_user = user
    session[:session_token] = user.reset_session_token!
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def logged_in?
    !!current_user
  end

  def current_user_id
    current_user ? current_user.id : nil
  end

  def current_user_username
    current_user ? current_user.username : nil
  end

  def require_current_user!
    redirect_to new_session_url unless current_user
  end

  def require_no_current_user!
    redirect_to root_url if current_user
  end

end
