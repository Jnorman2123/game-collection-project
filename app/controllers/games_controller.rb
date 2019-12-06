class GamesController < ApplicationController

  get '/games/wishlist' do
    redirect_if_not_logged_in
    @user = current_user
    @consoles = @user.consoles
    @games = @user.games
    erb :"/games/wishlist"
  end

  post '/games/wishlist' do
    redirect_if_not_logged_in
    game = Game.new(params)
    if !game.name.empty? && !game.price.empty?
      game.user_id = current_user.id
      game.save
      redirect "/games/wishlist"
    else
      incomplete_form
      redirect "/games/wishlist"
    end
  end

  get '/games/owned' do
    redirect_if_not_logged_in
    @user = current_user
    @consoles = @user.consoles
    @games = @user.games
    erb :"/games/owned"
  end

  post '/games/owned' do
    redirect_if_not_logged_in
    if game = Game.find_by_id(params[:game_id])
      game.console_id = params[:console_id]
      game.owned = true
      game.save
      redirect "/games/owned"
    else
      if !params[:name].empty?
        new_game = Game.new(params)
        new_game.user_id = current_user.id
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
    @user = current_user
    @game = Game.find_by_id(params[:id])
    erb :"/games/show"
  end

  delete '/games/:id' do
    redirect_if_not_logged_in
    @game = Game.find_by_id(params[:id])
    if @game.owned == true
      @game.delete
      redirect '/games/owned'
    else
      @game.delete
      redirect '/games/wishlist'
    end
  end
end
