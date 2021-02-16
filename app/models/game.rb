class Game < ApplicationRecord
  belongs_to :user_one, class_name: "User", optional: true
  belongs_to :user_two, class_name: "User", optional: true
  belongs_to :invite, optional: true
  has_many :rounds, dependent: :destroy

  after_update_commit do
    broadcast_replace
  end

  def update_points!(round)
    if round.winner
      if round.winner == user_one
        self.user_one_points += 1
      else
        self.user_two_points += 1
      end
    else
      if round.erring == user_one
        self.user_two_points += 1
      else
        self.user_one_points += 1
      end
    end
    if round == last_round
      self.finished = true
    end
    if is_over?
      user_one.update!(playing: false)
      user_two.update!(playing: false)
    end
    save!
  end

  def current_round
    @current_round ||= rounds.find_by(current: true)
  end

  def is_over?
    current_round == last_round && current_round.done?
  end

  def last_round
    rounds.order(:id).last
  end

  def winner
    if user_one_points > user_two_points
      user_one
    else
      user_two
    end
  end
end
