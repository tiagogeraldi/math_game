require 'rails_helper'

RSpec.describe Game, type: :model do
  it { is_expected.to belong_to(:user_one).class_name('User').optional }
  it { is_expected.to belong_to(:user_two).class_name('User').optional }
  it { is_expected.to belong_to(:invite).optional }
  it { is_expected.to have_many(:rounds).dependent(:destroy) }

  describe "#update_points!" do
    let(:game) { build(:game) }
    let(:round) { build(:round, game: game) }

    context "correct answer" do
      it "correct answer of user one" do
        round.user_one_answer = 30
        game.update_points!(round)

        expect(game.user_one_points).to eq 1
        expect(game.user_two_points).to eq 0
      end

      it "correct answer of user one" do
        round.user_two_answer = 30
        game.update_points!(round)

        expect(game.user_one_points).to eq 0
        expect(game.user_two_points).to eq 1
      end
    end

    context "wrong answer" do
      it "wrong answer of user one" do
        round.user_one_answer = 20
        game.update_points!(round)

        expect(game.user_one_points).to eq 0
        expect(game.user_two_points).to eq 1
      end

      it "wrong answer of user one" do
        round.user_two_answer = 20
        game.update_points!(round)

        expect(game.user_one_points).to eq 1
        expect(game.user_two_points).to eq 0
      end
    end

    it "updates playing when it's over" do
      game.user_one.playing = true
      game.user_two.playing = true
      allow(game).to receive(:is_over?).and_return(true)
      game.update_points!(round)

      expect(game.user_one.playing).to eq false
      expect(game.user_two.playing).to eq false
    end
  end

  context "#current_round" do
    it "returns round where current is true" do
      game = create(:game)
      round1 = create(:round, game: game, current: true)
      round2 = create(:round, game: game, current: false)

      expect(game.current_round).to eq round1
    end
  end

  context "#is_over?" do
    let(:game) { create(:game) }
    let!(:round1) { create(:round, game: game, current: false) }
    let!(:round2) { create(:round, game: game, current: true) }

    it "returns true if current round is the last round and it is done" do
      round2.update!(user_one_answer: 30)
      expect(game.is_over?).to be_truthy
    end

    it "returns false if current round is not done" do
      expect(game.is_over?).to be_falsey
    end

    it "returns false if the current round is not the last one" do
      round2.update!(current: false)
      expect(game.is_over?).to be_falsey
    end
  end

  context "#last_round" do
    it "returns the last round by id" do
      game = create(:game)
      round1 = create(:round, game: game)
      round2 = create(:round, game: game)

      expect(game.last_round).to eq(round2)
    end
  end

  context "#winner" do
    let(:game) { build(:game) }

    it "user one is the winner" do
      game.user_one_points = 2
      game.user_two_points = 1
      expect(game.winner).to eq(game.user_one)
    end

    it "user two is the winner" do
      game.user_one_points = 1
      game.user_two_points = 2
      expect(game.winner).to eq(game.user_two)
    end
  end
end
