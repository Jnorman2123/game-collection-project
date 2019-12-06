class SetGameOwnedDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :games, :owned, :boolean, :default => false
  end
end
