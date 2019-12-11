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
    if User.find_by_name(params[:name])
      flash[:notice] = "That username is already taken."
      redirect '/users/signup'
    elsif User.find_by_email(params[:email])
      flash[:notice] = "An account with that email already exists."
      redirect '/users/signup'
    elsif params[:name].empty? || params[:email].empty? || params[:password].empty?
      incomplete_form
      redirect '/users/signup'
    else
      user = User.new(params)
      user.save
      session[:user_id] = user.id
      flash[:notice] = "Congrats #{user.name} you have successfully signed up!"
      redirect "/users/#{user.id}"
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
