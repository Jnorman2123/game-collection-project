require './config/environment'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'game colletion'
    register Sinatra::Flash
  end

  get "/" do
    erb :homepage
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      current_user ||= User.find(session[:user_id])
    end

    def redirect_if_not_logged_in
      if !logged_in?
        flash[:notice] = "You need to be logged in to do that."
        redirect "/"
      end
    end

    def redirect_if_logged_in
      if logged_in?
        flash[:notice] = "You are already logged in."
        redirect "users/#{current_user.id}"
      end
    end

    def incomplete_form
      flash[:notice] = "Please fill in all fields."
    end

    def validate_user(item) 
      if item.user_id != current_user.id 
        flash[:notice] = "You can only interact with consoles associated with your account."
        redirect "/users/#{current_user.id}"
      end
    end 

    def invalid_item(item)
      flash[:notice] = "#{item} does not exist."
      redirect "/users/#{current_user.id}"
    end 
  end
end
