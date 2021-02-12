class MoveConfirmation < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :user_one_ready
    remove_column :games, :user_two_ready

    add_column :invites, :from_ready, :boolean
    add_column :invites, :to_ready, :boolean
  end
end
