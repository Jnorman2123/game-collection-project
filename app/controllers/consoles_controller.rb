class ConsolesController < ApplicationController

  get '/consoles/wishlist' do
    redirect_if_not_logged_in
    @user = current_user
    @consoles = @user.consoles
    erb :"/consoles/wishlist"
  end

  post '/consoles/wishlist' do
    redirect_if_not_logged_in
    console = Console.new(params)
    if !console.name.empty? && !console.price.empty?
      console.user_id = current_user.id
      console.save
      redirect "/consoles/wishlist"
    else
      incomplete_form
      redirect "/consoles/wishlist"
    end
  end

  get '/consoles/owned' do
    redirect_if_not_logged_in
    @user = current_user
    @consoles = @user.consoles
    erb :"/consoles/owned"
  end

  post '/consoles/owned' do
    redirect_if_not_logged_in
    if console = Console.find_by_id(params[:console_id])
      console.user_id = current_user.id
      console.save
      redirect :"/consoles/owned"
    else
      if !params[:name].empty?
        new_console = Console.create(params)
        new_console.user_id = current_user.id
        new_console.save
        redirect :"/consoles/owned"
      else
        incomplete_form
        redirect :"/consoles/owned"
      end
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
