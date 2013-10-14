class UsersController < ApplicationController
  def create
    @username = params[:username]
    @password = params[:password]

    #sign_in
    create_user
  end


  def sign_in

    username = 'Blackbaud\\' + @username
    ldap = Net::LDAP.new
    ldap.host = '172.20.0.185'
    ldap.port = 389
    ldap.auth username, @password

    #create_user
  end

  def create_user
    @user = User.find_by_username @username
    if @user == nil
      @user = User.new(:username => @username)
      @user.save
    end

    login_user @username
    redirect_to root_path
  end
end
