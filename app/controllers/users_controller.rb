require_relative '../helpers/login_helper'

class UsersController < ApplicationController

  def home
    if logged_in?
      redirect_to metrics_path
    end
  end

  def create
    @username = params[:username]
    @password = params[:password]

    if create_user
      redirect_to metrics_path
    else
      redirect_to login_path
    end
  end

  def logout
    logout_user
  end


  def create_user
    if authenticate_user(@username, @password)
      if User.find_by_username(@username).nil?
        @user = User.new(:username => @username)
        if @user.save
          login_user @username
        else
          false
        end
      else
        login_user @username
      end
    else
      false
    end
  end

end
