class Invite < ApplicationRecord
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'

  after_create_commit do
    broadcast_prepend_later_to to_id, :pending_invites
  end

  after_update_commit do
    if accepted != true
      broadcast_replace_to to_id, :pending_invites
    end
  end
end
