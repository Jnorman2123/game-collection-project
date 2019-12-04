class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.decimal :price
      t.interger :console_id
      t.integer :user_id
    end
  end
end
