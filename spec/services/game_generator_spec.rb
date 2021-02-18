require 'rails_helper'

RSpec.describe GameGenerator do
  let(:invite) { create(:invite) }

  describe "#run!" do
    it "creates a game" do
      expect do
        described_class.new(invite).run!
      end.to change { Game.count }.by(1)

      game = Game.last
      expect(game.user_one).to eq invite.from
      expect(game.user_two).to eq invite.to
      expect(game.invite).to eq invite
    end

    it "creates rounds" do
      expect do
        described_class.new(invite).run!
      end.to change { Round.count }.by(5)

      round = Round.last
      expect(round.correct_answer).to eq eval(round.description)
      expect(round.alternatives).to include round.correct_answer
    end
  end
end
