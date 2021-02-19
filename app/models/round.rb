class Round < ApplicationRecord
  belongs_to :game

  attr_accessor :guess

  validate :only_first_answer, on: :update

  def answer
    user_one_answer || user_two_answer
  end

  def winner
    if user_one_answer && user_one_answer == correct_answer
      game.user_one
    elsif user_two_answer && user_two_answer == correct_answer
      game.user_two
    end
  end

  def erring
    if user_one_answer && user_one_answer != correct_answer
      game.user_one
    elsif user_two_answer && user_two_answer != correct_answer
      game.user_two
    end
  end

  def done?
    winner || erring
  end

  def next
    game.rounds.where('id > ?', id).first
  end

  def index
    game.rounds.order(:id).index(self)
  end

  private

  def only_first_answer
    if user_one_answer_changed? && user_two_answer.present?
      errors.add :user_one_answer, "you can't answer anymore"
    elsif user_two_answer_changed? && user_one_answer.present?
      errors.add :user_two_answer, "you can't answer anymore"
    end
  end
end
