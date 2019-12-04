class UsersController < ApplicationController

  get '/login' do
    redirect_if_logged_in
    erb :"/users/login"
  end

  post '/login' do

    redirect '/home'
  end

  get '/home' do
    redirect_if_not_logged_in
    erb :"/users/home"
  end

  get '/signup' do
    redirect_if_logged_in
    erb :"/users/signup"
  end

  post '/signup' do
    binding.pry
    user = User.new(params)
    user.save
    redirect '/login'
  end

  get '/logout' do

    redirect '/'
  end

end
