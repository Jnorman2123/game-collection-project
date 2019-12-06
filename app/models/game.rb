class Game < ActiveRecord::Base
  belongs_to :user
  belongs_to :console

  def self.owned_games(games)
    games.select{|game| game.owned == true}
  end

  def self.wishlist_games(games)
    games.select{|game| game.owned == false}
  end
end
