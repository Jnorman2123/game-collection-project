class UsersController < ApplicationController

  get '/users/login' do
    redirect_if_logged_in
    erb :"/users/login"
  end

  post '/users/login' do
    user = User.find_by_name(params[:name])
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  end

  get '/users/:id' do
    redirect_if_not_logged_in
    @user = User.find_by_id(params[:id])
    erb :"/users/home"
  end

  get '/users/signup' do
    redirect_if_logged_in
    erb :"/users/signup"
  end

  post '/users/signup' do
    user = User.new(params)
    user.save
    redirect 'users/login'
  end

  post '/users/logout' do
    session.clear
    binding.pry
    redirect '/'
  end

end
