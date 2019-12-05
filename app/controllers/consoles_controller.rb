class ConsolesController < ApplicationController

  get '/consoles/wishlist' do
    redirect_if_not_logged_in
    @user = current_user
    @consoles = Console.all
    erb :"/consoles/wishlist"
  end

  post '/consoles/wishlist' do
    redirect_if_not_logged_in
    console = Console.new(params)
    console.save
    redirect "/consoles/wishlist"
  end

  get '/consoles/owned' do
    redirect_if_not_logged_in
    @user = current_user
    @consoles = Console.all
    erb :"/consoles/owned"
  end

  post '/consoles/owned' do
    redirect_if_not_logged_in
    if console = Console.find_by_id(params[:id])
      console.user_id = current_user.id
      console.save
      redirect :"/consoles/owned"
    else
      new_console = Console.create(params)
      new_console.user_id = current_user.id
      new_console.save
      redirect :"/consoles/owned"
    end
  end

  get '/consoles/:id' do
    redirect_if_not_logged_in
    @user = current_user
    @console = Console.find_by_id(params[:id])
    erb :"/consoles/show"
  end

  delete '/consoles/:id' do
    redirect_if_not_logged_in
    @console = Console.find_by_id(params[:id])
    if @console.user_id != nil
      @console.delete
      redirect '/consoles/owned'
    else
      @console.delete
      redirect '/consoles/wishlist'
    end
  end
end
