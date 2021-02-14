class NullableGames < ActiveRecord::Migration[6.1]
  def change
    change_column :games, :user_one_id, :integer, null: true
    change_column :games, :user_two_id, :integer, null: true
    change_column :games, :invite_id, :integer, null: true
  end
end
