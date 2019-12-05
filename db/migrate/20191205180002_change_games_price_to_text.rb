class ChangeGamesPriceToText < ActiveRecord::Migration
  def change
    change_column :games, :price, :string
  end
end
