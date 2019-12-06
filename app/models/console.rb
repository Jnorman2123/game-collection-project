class Console < ActiveRecord::Base
  belongs_to :user
  has_many :games

  def self.owned_consoles(consoles)
    consoles.select{|console| console.owned == true}
  end

  def self.wishlist_consoles(consoles)
    consoles.select{|console| console.owned == false}
  end
end
