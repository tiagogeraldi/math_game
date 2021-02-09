class Invite < ApplicationRecord
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'
  has_one :game, dependent: :destroy

  after_create_commit do
    broadcast_prepend_to to_id, :received_invites, partial: "/invites/received_invite"
    broadcast_prepend_to from_id, :sent_invites, partial: "/invites/sent_invite"
  end

  after_update_commit do
    broadcast_replace_to to_id, :received_invites, partial: "/invites/received_invite"
    broadcast_replace_to from_id, :sent_invites, partial: "/invites/sent_invite"
  end

  after_destroy_commit do
    broadcast_remove
  end

  scope :not_answered, -> { where(accepted: nil) }
end
