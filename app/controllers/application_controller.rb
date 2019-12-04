require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'game colletion'
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
        redirect "/"
      end
    end

    def redirect_if_logged_in
      if logged_in?
        redirect "/home"
      end
    end
  end

end
