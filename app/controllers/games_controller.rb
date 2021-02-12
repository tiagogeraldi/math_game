class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    Game.transaction do
      @game.assign_attributes(permitted_params)
      @game.save!
      if @game.canceled
        @game.user_one.update!(playing: false)
        @game.user_two.update!(playing: false)
      end
    end
    render action: :show
  end

  private

  def permitted_params
    params.require(:game).permit(:canceled)
  end
end
