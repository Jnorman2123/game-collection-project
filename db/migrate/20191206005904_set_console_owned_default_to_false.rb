class SetConsoleOwnedDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :consoles, :owned, :boolean, :default => false
  end
end
