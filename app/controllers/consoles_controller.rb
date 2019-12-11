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
    binding.pry
    @console = Console.find_by_id(params[:id])
    validate_user(@console)
    if @console.owned == true
      erb :"/consoles/owned_show"
    else
      erb :"/consoles/wishlist_show"
    end
  end

  patch '/consoles/:id' do
    redirect_if_not_logged_in
    @console = Console.find_by_id(params[:id])
    validate_user(@console)
    if @console.owned == true
      @console.update(name: params[:name])
      redirect '/consoles/owned'
    else
      @console.update(name: params[:name], price: params[:price])
      redirect '/consoles/wishlist'
    end
  end

  delete '/consoles/:id' do
    redirect_if_not_logged_in
    @console = Console.find_by_id(params[:id])
    validate_user(@console)
    if @console.owned == true
      @console.delete
      redirect '/consoles/owned'
    else
       @console.delete
      redirect '/consoles/wishlist'
    end
  end

  private 

  def set_game 
    @game = Game.find_by_id(params[:id])
  end 

  def owned? 
    @game.owned
  end 

  def update_game 
    params.delete("_method")
    @game.update(params)
  end 

  def delete_game 
    @game.delete
  end 

  def validate_game_user
      if @game.user_id != current_user.id 
        flash[:notice] = "You can only interact with games associated with your account."
        redirect "/users/#{current_user.id}"
      end
    end 

    def invalid_game
      flash[:notice] = "Game does not exist."
      redirect "/users/#{current_user.id}"
    end 
end
