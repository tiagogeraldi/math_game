class Game < ApplicationRecord
  belongs_to :user_one, class_name: "User"
  belongs_to :user_two, class_name: "User"
  has_many :rounds, dependent: :destroy

  attr_accessor :i_am_ready

  after_create_commit do
    broadcast_prepend_later_to user_one_id, :pending_game,
      partial: 'games/pending_game', locals: { game: self }
    broadcast_prepend_later_to user_two_id, :pending_game,
      partial: 'games/pending_game', locals: { game: self }
  end

  after_update_commit do
    broadcast_replace
  end
end
