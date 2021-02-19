require 'rails_helper'

RSpec.describe 'Games', type: :request do
  let(:game) { create :game }

  before do
    sign_in 'John'
  end

  describe 'GET /games/id' do
    it 'displays a game' do
      get game_path(game)

      expect(response).to have_http_status(200)
      expect(response.body).to include game.user_one.name
    end
  end

  describe 'PUT /games/id' do
    it 'cancels a game' do
      put game_path(game), as: :turbo_stream, params: {
        game: { canceled: true }
      }
      expect(game.reload.canceled).to eq true
      expect(response).to have_http_status(200)
    end
  end
end
