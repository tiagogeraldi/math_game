class RoundsController < ApplicationController
  def update
    @game = Game.find(params[:game_id])
    @round = @game.rounds.find(params[:id])
    @round.assign_attributes(permitted_params)

    if @game.user_one == current_user
      @round.user_one_answer = @round.guess
    else
      @round.user_two_answer = @round.guess
    end

    Round.transaction do
      current_changed = @round.current_changed?
      if @round.save
        @game.update_points(@round)
        @game.save!
        if current_changed
          @game.rounds.where.not(id: @round.id).update_all(current: false)
        end
      else
        flash[:error] = @round.errors.full_messages.join('. ')
      end
    end
    redirect_to @game
  end

  private

  def permitted_params
    params.require(:round).permit(:guess, :current)
  end
end
