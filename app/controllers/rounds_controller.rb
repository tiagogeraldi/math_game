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
      next_round = @round.current_changed?
      answered = @round.user_one_answer_changed? || @round.user_two_answer_changed?

      if @round.save
        if answered
          @game.update_points!(@round)
          if @game.is_over?
            @game.user_one.update!(playing: false)
            @game.user_two.update!(playing: false)
          end
        end
        if next_round
          @game.rounds.where.not(id: @round.id).update_all(current: false)
          @game.touch(:updated_at) # force re-broadcast
        end
      else
        flash[:error] = @round.errors.full_messages.join('. ')
      end
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@round.game)
      end
    end
  end

  private

  def permitted_params
    params.require(:round).permit(:guess, :current)
  end
end
