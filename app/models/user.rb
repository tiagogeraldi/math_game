class User < ApplicationRecord
  after_create_commit do
    broadcast_prepend_to "users"
  end

  after_destroy_commit do
    broadcast_remove_to "users"
  end

  has_many :sent_invites, class_name: 'Invite', foreign_key: :from_id, dependent: :destroy
  has_many :received_invites, class_name: 'Invite', foreign_key: :to_id, dependent: :destroy

  has_many :games_as_user_one, class_name: 'Game', foreign_key: :user_one_id, dependent: :nullify
  has_many :games_as_user_two, class_name: 'Game', foreign_key: :user_two_id, dependent: :nullify

  def invites
    Invite.left_outer_joins(:game).
      where("from_id = :id OR to_id = :id", id: id).
      where.not(game: { canceled: true })
  end
end
