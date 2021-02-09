class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    Game.transaction do
      @game.assign_attributes(permitted_params)
      set_ready
      @game.save!
      if @game.canceled
        @game.user_one.update!(playing: false)
        @game.user_two.update!(playing: false)
        redirect_to welcomes_path
      else
        current_user.update!(playing: true)
        @game.rounds.first.update!(current: true)
        redirect_to @game
      end
    end
  end

  private

  def permitted_params
    params.require(:game).permit(:i_am_ready, :canceled)
  end

  def set_ready
    return unless @game.i_am_ready
    if current_user.id == @game.user_one_id
      @game.user_one_ready = true
    else
      @game.user_two_ready = true
    end
  end
end
