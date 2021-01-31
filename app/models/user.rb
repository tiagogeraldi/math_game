class User < ApplicationRecord
  broadcasts_to ->(user) { :users }

  has_many :sent_invites, class_name: 'Invite', foreign_key: :from_id, dependent: :destroy
  has_many :received_invites, class_name: 'Invite', foreign_key: :to_id, dependent: :destroy

  has_many :games_as_user_one, class_name: 'Game', foreign_key: :user_one_id, dependent: :nullify
  has_many :games_as_user_two, class_name: 'Game', foreign_key: :user_two_id, dependent: :nullify

  def pending_invites
    received_invites.where(accepted: nil)
  end

  def games
    Game.where("user_one_id = :id OR user_two_id = :id", id: id)
  end

  def pending_games
    Game.where(canceled: false).
      where(
      "(user_one_id = :id AND user_one_ready = false) OR
       (user_two_id = :id AND user_two_ready = false)",
       id: id
    )
  end
end
