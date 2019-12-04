class ConsolesController < ApplicationController

  get '/consoles/wishlist' do
    redirect_if_not_logged_in
    erb :"/consoles/wishlist"
  end

  post '/consoles/wishlist' do
    redirect_if_not_logged_in
    redirect "/consoles/wishlist"
  end

  get '/consoles/owned' do
    redirect_if_not_logged_in
    erb :"/consoles/owned"
  end

  post '/consoles/owned' do
    redirect_if_not_logged_in
    redirect :"/consoles/owned"
  end

  get '/consoles/:id' do
    redirect_if_not_logged_in
    erb :"/consoles/#{@console.id}"
  end
end
