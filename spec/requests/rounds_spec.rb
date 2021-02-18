require 'rails_helper'

RSpec.describe "Rounds", type: :request do
  let(:john) { User.find_by(name: "John") }
  let(:game) { create(:game, user_one: john) }
  let(:round1) { create(:round, current: true, game: game) }
  let(:round2) { create(:round, game: game) }

  before do
    sign_in "John"
  end

  describe "GET /rounds/id" do
    it "sets current round" do
      round1
      get game_round_path(game, round2), as: :turbo_stream

      expect(round2.reload.current).to eq true
      expect(round1.reload.current).to eq false
      expect(response.body).to include "turbo-stream"
    end
  end

  describe "PUT /rounds/1" do
    it "receives an answer from user one" do
      put game_round_path(game, round1), as: :turbo_stream, params: {
        round: {
          guess: 20
        }
      }
      expect(response.body).to include "turbo-stream"
      game.reload
      expect(round1.reload.user_one_answer).to eq 20
      expect(game.user_one_points).to eq 0
      expect(game.user_two_points).to eq 1
    end

    it "receives an answer from user two" do
      sign_in "Peter"
      game.update!(user_two: User.find_by(name: "Peter"))

      put game_round_path(game, round1), as: :turbo_stream, params: {
        round: {
          guess: 20
        }
      }
      expect(response.body).to include "turbo-stream"
      game.reload
      expect(round1.reload.user_two_answer).to eq 20
      expect(game.user_one_points).to eq 1
      expect(game.user_two_points).to eq 0
    end
  end
end
