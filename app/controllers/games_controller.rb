class GamesController < ApplicationController

  get '/games/wishlist' do
    redirect_if_not_logged_in
    @user = current_user
    @games = Game.all
    erb :"/games/wishlist"
  end

  post '/games/wishlist' do
    redirect_if_not_logged_in
    game = Game.new(params)
    game.save
    redirect "/games/wishlist"
  end

  get '/games/owned' do
    redirect_if_not_logged_in
    @user = current_user
    @games = Game.all
    binding.pry
    erb :"/games/owned"
  end

  post '/games/owned' do
    redirect_if_not_logged_in
    game = Game.find_by_id(params[:game_id])
    game.user_id = current_user.id
    game.save
    redirect :"/games/owned"
  end

  get '/games/:id' do
    redirect_if_not_logged_in
    @game = Game.find_by_id(params[:id])
    erb :"/games/show"
  end

  delete '/games/:id' do
    redirect_if_not_logged_in
    @game = Game.find_by_id(params[:id])
    @game.delete
    redirect '/games/owned'
  end
end
