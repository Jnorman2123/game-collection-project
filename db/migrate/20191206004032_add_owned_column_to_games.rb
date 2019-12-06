class AddOwnedColumnToGames < ActiveRecord::Migration
  def change
    add_column :games, :owned, :boolean
  end
end
