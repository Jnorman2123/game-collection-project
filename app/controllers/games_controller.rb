class GamesController < ApplicationController

  get '/games/wishlist' do
    redirect_if_not_logged_in
    @owned_consoles = Console.owned_consoles(current_user.consoles)
    @wishlist_games = Game.wishlist_games(current_user.games)
    erb :"/games/wishlist"
  end

  post '/games/wishlist' do
    redirect_if_not_logged_in
    game = current_user.games.build(params)
    if !game.name.empty? && !game.price.empty?
      game.save
      redirect "/games/wishlist"
    else
      incomplete_form
      redirect "/games/wishlist"
    end
  end

  get '/games/owned' do
    redirect_if_not_logged_in
    @owned_consoles = Console.owned_consoles(current_user.consoles)
    @owned_games = Game.owned_games(current_user.games)
    erb :"/games/owned"
  end

  post '/games/owned' do
    redirect_if_not_logged_in
    game = current_user.games.find_by_id(params[:game_id])
    if game && params[:console_id]
      game.console_id = params[:console_id]
      game.owned = true
      game.save
      redirect "/games/owned"
    elsif !params[:console_id]
      incomplete_form
      redirect "/games/wishlist"
    else
      if !params[:name].empty? && params[:console_id]
        new_game = current_user.games.build(params)
        new_game.owned = true
        new_game.save
        redirect "/games/owned"
      else
        incomplete_form
        redirect "/games/owned"
      end
    end
  end

  get '/games/:id' do
    redirect_if_not_logged_in
    set_game
    @owned_consoles = Console.owned_consoles(current_user.consoles)
    if owned?
      erb :"/games/owned_show"
    else 
      erb :"/games/wishlist_show"
    end
  end

  patch '/games/:id' do
    redirect_if_not_logged_in
    set_game
    @owned_consoles = Console.owned_consoles(current_user.consoles)
    if owned?
      @game.update(name: params[:name])
      redirect '/games/owned'
    else
      @game.update(name: params[:name], price: params[:price])
      redirect '/games/wishlist'
    end
  end

  delete '/games/:id' do
    redirect_if_not_logged_in
    set_game
    if owned?
      @game.delete
      redirect '/games/owned'
    else
      @game.delete
      redirect '/games/wishlist'
    end
  end

  private 

  def set_game 
    @game = Game.find_by_id(params[:id])
  end 

  def owned? 
    @game.owned
  end 
end
