class Game < ApplicationRecord
  belongs_to :user_one, class_name: "User"
  belongs_to :user_two, class_name: "User"
  belongs_to :invite
  has_many :rounds, dependent: :destroy

  attr_accessor :i_am_ready

  after_update_commit do
    broadcast_replace
  end

  def create_rounds!
    5.times do
      equation = random_equation
      rounds << Round.new(
        description: equation,
        correct_answer: eval(equation)
      )
    end
  end

  def running?
    user_one_ready && user_two_ready
  end

  def update_points(round)
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
  end

  private

  def random_equation
    numbers = elements
    numbers.map.with_index do |el, idx|
      "#{el} #{operator if idx < (numbers.size - 1)} "
    end.join
  end

  def elements
    list = []
    rand(2..10).times do
      list << rand(1..30)
    end
    list
  end

  def operator
    ['+', '-', '/', '*'].sample
  end
end
