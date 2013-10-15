require 'net-ldap'

module LoginHelper
  module_function

  def authenticate_user username, password
    bb_username = 'Blackbaud\\' + username
    ldap = Net::LDAP.new
    ldap.host = '172.20.0.185'
    ldap.port = 389
    ldap.auth bb_username, password
    ldap.bind
  end

  def login_user(username)
    session[:user] = username
    cookies.permanent[:user] = username
  end

  def logout_user
    cookies.delete :user
    reset_session
    redirect_to login_path
  end

  def logged_in?
    session[:user] != nil
  end

end