class AddPriceToConsoles < ActiveRecord::Migration
  def change
    add_column :consoles, :price, :string
  end
end
