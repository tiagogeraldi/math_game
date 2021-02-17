require 'rails_helper'

RSpec.describe Round, type: :model do
  it { is_expected.to belong_to(:game) }

  describe "#only_first_answer" do
    it "does not allow user two after user one" do
      round = create(:round, user_one_answer: 10)
      round.user_two_answer = 10

      expect(round.valid?).to eq(false)
      expect(round.errors.messages).to eq({ user_two_answer: ["you can't answer anymore"] })
    end

    it "does not allow user one after user two" do
      round = create(:round, user_two_answer: 10)
      round.user_one_answer = 20

      expect(round.valid?).to eq(false)
      expect(round.errors.messages).to eq({ user_one_answer: ["you can't answer anymore"] })
    end
  end

  describe "#winner" do
    it "user one winner" do
      round = build(:round, user_one_answer: 30)
      expect(round.winner).to eq(round.game.user_one)
    end

    it "user two winner" do
      round = build(:round, user_two_answer: 30)
      expect(round.winner).to eq(round.game.user_two)
    end
  end

  describe "#erring" do
    it "user one erring" do
      round = build(:round, user_one_answer: 20)
      expect(round.erring).to eq(round.game.user_one)
    end

    it "user two erring" do
      round = build(:round, user_two_answer: 20)
      expect(round.erring).to eq(round.game.user_two)
    end
  end

  describe "#done?" do
    it "rounds is done if there is a winner" do
      allow(subject).to receive(:winner).and_return(true)
      expect(subject.done?). to eq true
    end

    it "rounds is done if there is an erring" do
      allow(subject).to receive(:erring).and_return(true)
      expect(subject.done?). to eq true
    end

    it "is not done" do
      expect(subject.done?).to be_falsey
    end
  end

  describe "#next" do
    it "returns next round" do
      game = create(:game)
      round1 = create(:round, game: game)
      round2 = create(:round, game: game)
      round3 = create(:round, game: game)

      expect(round1.next).to eq(round2)
      expect(round2.next).to eq(round3)
    end
  end

  describe "#index" do
    it "returns index position of ther round" do
      game = create(:game)
      round1 = create(:round, game: game)
      round2 = create(:round, game: game)

      expect(round1.index).to eq(0)
      expect(round2.index).to eq(1)
    end
  end
end
