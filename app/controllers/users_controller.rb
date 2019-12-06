class UsersController < ApplicationController

  get '/users/login' do
    redirect_if_logged_in
    erb :"/users/login"
  end

  post '/users/login' do
    user = User.find_by_name(params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome to your homepage #{user.name}!"
      redirect "/users/#{user.id}"
    else
      flash[:notice] = "Invalid name or password"
      redirect '/users/login'
    end
  end

  get '/users/signup' do
    redirect_if_logged_in
    erb :"/users/signup"
  end

  post '/users/signup' do
    if !params[:name].empty? && !params[:email].empty? && !params[:password].empty?
      user = User.new(params)
      user.save
      flash[:notice] = "Congrats #{user.name} you have successfully signed up!"
      redirect 'users/login'
    else
      incomplete_form
      redirect '/users/signup'
    end
  end

  get '/users/:id' do
    redirect_if_not_logged_in
    @user = current_user
    erb :"/users/home"
  end

  post '/users/logout' do
    if logged_in?
      session.clear
      redirect '/'
    end
  end

end
