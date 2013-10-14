class ApplicationController < ActionController::Base
  protect_from_forgery

  def login_user(username)
    session[:user] = username
    cookies.permanent[:user] = username
  end

  def logout_user
    cookies.delete :user
    reset_session
    redirect_to_login
  end

  def logged_in?
    session[:user] != nil
  end

  def redirect_to_login
    redirect_to '/home'
  end
end
