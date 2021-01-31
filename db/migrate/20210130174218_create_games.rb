class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.integer :user_one_id
      t.integer :user_two_id
      t.integer :user_one_points, default: 0
      t.integer :user_two_points, default: 0
      t.integer :round
      t.boolean :user_one_ready, default: false
      t.boolean :user_two_ready, default: false

      t.timestamps
    end

    add_foreign_key :games, :users, column: :user_one_id
    add_foreign_key :games, :users, column: :user_two_id
    add_index :games, :user_one_id
    add_index :games, :user_two_id
  end
end
