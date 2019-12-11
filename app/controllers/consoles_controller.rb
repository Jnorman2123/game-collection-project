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
    if set_console
      validate_console_user
      if owned?
        erb :"/consoles/owned_show"
      else
        erb :"/consoles/wishlist_show"
      end
    else 
      invalid_console 
    end 
  end

  patch '/consoles/:id' do
    redirect_if_not_logged_in
    if set_console 
      validate_console_user
      if owned?
        update_console
        redirect '/consoles/owned'
      else
        update_console
        redirect '/consoles/wishlist'
      end
    else 
      invalid_console 
    end 
  end

  delete '/consoles/:id' do
    redirect_if_not_logged_in
    if set_console 
      validate_console_user
      if owned?
        delete_console
        redirect '/consoles/owned'
      else
        delete_console
        redirect '/consoles/wishlist'
      end
    else 
      invalid_console 
    end 
  end

  private 

  def set_console 
    @console = Console.find_by_id(params[:id])
  end 

  def owned? 
    @console.owned
  end 

  def update_console 
    params.delete("_method")
    @console.update(params)
  end 

  def delete_console 
    @console.delete
  end 

  def validate_console_user
      if @console.user_id != current_user.id 
        flash[:notice] = "You can only interact with consoles associated with your account."
        redirect "/users/#{current_user.id}"
      end
    end 

    def invalid_console
      flash[:notice] = "Console does not exist."
      redirect "/users/#{current_user.id}"
    end 
end
