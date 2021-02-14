# Creates rounds and alternatives for a recent created Game.
class GameGenerator
  # The equations are randomically generated.
  # They have between 2 to 6 elements and the numbers
  # can be 1 to 15
  MAX_EQUATION_ELEMENTS = 6
  MAX_EQUATION_NUMBER = 15

  attr_reader :game, :invite

  def initialize(invite)
    @invite = invite
  end

  def run!
    create_game
    create_rounds

    game.rounds.first.update!(current: true)
    invite.from.update!(playing: true)
    invite.to.update!(playing: true)
  end

  private

  def create_game
    @game = Game.create!(
      invite: invite,
      user_one: invite.from,
      user_two: invite.to,
    )
  end

  def create_rounds
    5.times do
      equation = random_equation
      correct_answer = eval(equation)

      game.rounds << Round.new(
        description: equation,
        correct_answer: correct_answer,
        alternatives: [
          correct_answer,
          rand(-100..500),
          rand(0..100),
          rand(0..20)
        ]
      )
    end
  end

  def random_equation
    numbers = elements
    numbers.map.with_index do |el, idx|
      "#{el} #{operator if idx < (numbers.size - 1)} "
    end.join
  end

  # Random elements for a new equation
  def elements
    list = []
    rand(2..MAX_EQUATION_ELEMENTS).times do
      list << rand(1..MAX_EQUATION_NUMBER)
    end
    list
  end

  def operator
    ['+', '-', '*'].sample
  end
end
