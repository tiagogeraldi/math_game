class WelcomesController < ApplicationController
  def index
    @users = User.where(playing: false)

    if current_user
      @invites = current_user.pending_invites
      @games = current_user.pending_games
    end
  end
end
