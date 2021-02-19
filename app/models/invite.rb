class Invite < ApplicationRecord
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'
  has_one :game, dependent: :nullify

  after_create_commit do
    broadcast_prepend_to to_id, :invites, partial: '/invites/received'
    broadcast_prepend_to from_id, :invites, partial: '/invites/sent'
  end

  after_update_commit do
    broadcast_replace_to to_id, :invites
    broadcast_replace_to from_id, :invites
  end

  after_destroy_commit do
    broadcast_remove_to to_id, :invites
    broadcast_remove_to from_id, :invites
  end

  attr_accessor :i_am_ready

  scope :not_answered, -> { where(accepted: nil) }

  def ready?
    from_ready && to_ready
  end

  def am_i_ready?(user)
    (from_ready && from == user) || (to_ready && to == user)
  end
end
