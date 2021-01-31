class CreateRounds < ActiveRecord::Migration[6.1]
  def change
    create_table :rounds do |t|
      t.references :game, null: false, foreign_key: true
      t.float :user_one_answer
      t.float :user_two_answer
      t.string :description
      t.float :correct_answer

      t.timestamps
    end
  end
end
