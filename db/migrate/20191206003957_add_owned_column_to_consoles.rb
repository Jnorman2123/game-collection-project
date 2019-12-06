class AddOwnedColumnToConsoles < ActiveRecord::Migration
  def change
    add_column :consoles, :owned, :boolean
  end
end
