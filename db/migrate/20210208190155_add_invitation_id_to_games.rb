class AddInvitationIdToGames < ActiveRecord::Migration[6.1]
  def change
    add_reference :games, :invite, index: true, foreign_key: true
  end
end
