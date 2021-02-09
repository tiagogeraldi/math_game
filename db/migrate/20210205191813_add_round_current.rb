class AddRoundCurrent < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :round
    add_column :rounds, :current, :boolean, default: false
  end
end
