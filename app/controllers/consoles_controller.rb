class ConsolesController < ApplicationController

  get '/consoles/wishlist' do
    redirect_if_not_logged_in
    @wishlist_consoles = Console.wishlist_consoles(current_user.consoles)
    erb :"/consoles/wishlist"
  end

  post '/consoles/wishlist' do
    redirect_if_not_logged_in
    console = current_user.consoles.build(params)
    if !console.name.empty? && !console.price.empty?
      console.save
      redirect "/consoles/wishlist"
    else
      incomplete_form
      redirect "/consoles/wishlist"
    end
  end

  get '/consoles/owned' do
    redirect_if_not_logged_in
    @owned_consoles = Console.owned_consoles(current_user.consoles)
    erb :"/consoles/owned"
  end

  post '/consoles/owned' do
    redirect_if_not_logged_in
    if console = Console.find_by_id(params[:console_id])
      console.owned = true
      console.save
      redirect :"/consoles/owned"
    else
      if !params[:name].empty?
        new_console = current_user.consoles.build(params)
        new_console.owned = true
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
    @console = Console.find_by_id(params[:id])
    if @console.owned == true
      erb :"/consoles/owned_show"
    elsif @console.owned == false
      erb :"/consoles/wishlist_show"
    end
  end

  patch '/consoles/:id' do
    redirect_if_not_logged_in
    @console = Console.find_by_id(params[:id])
    if @console.owned == true
      @console.update(name: params[:name])
      redirect '/consoles/owned'
    else
      @console.update(name: params[:name])
      redirect '/consoles/wishlist'
    end
  end

  delete '/consoles/:id' do
    redirect_if_not_logged_in
    @console = Console.find_by_id(params[:id])
    if @console.owned == true
      @console.delete
      redirect '/consoles/owned'
    else
      @console.delete
      redirect '/consoles/wishlist'
    end
  end
end
