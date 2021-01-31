class AddCanceledToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :canceled, :boolean, default: false
  end
end
