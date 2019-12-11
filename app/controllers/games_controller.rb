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
    if set_game
      @owned_consoles = Console.owned_consoles(current_user.consoles)
      validate_game_user
      erb :"/games/show"
    else 
      invalid_game
    end 
  end

  patch '/games/:id' do
    redirect_if_not_logged_in
    if set_game
      @owned_consoles = Console.owned_consoles(current_user.consoles)
      validate_game_user
      if owned?
        update_game
        redirect '/games/owned'
      else
        update_game
        redirect '/games/wishlist'
      end
    else
      invalid_game
    end 
  end

  delete '/games/:id' do
    redirect_if_not_logged_in
    if set_game
      validate_game_user
      if owned?
        delete_game
        redirect '/games/owned'
      else
        delete_game
        redirect '/games/wishlist'
      end
    else
      invalid_game
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
