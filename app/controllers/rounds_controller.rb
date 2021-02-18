class RoundsController < ApplicationController
  def update
    @game = Game.find(params[:game_id])
    @round = @game.rounds.find(params[:id])
    @round.assign_attributes(permitted_params)

    assign_answer_attributes

    Round.transaction do
      @round.save!
      @game.update_points!(@round)
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@round.game)
      end
    end
  end

  # Next round
  def show
    @game = Game.find(params[:game_id])
    @round = @game.rounds.find(params[:id])

    Round.transaction do
      @round.update!(current: true)
      @game.rounds.where.not(id: @round.id).update_all(current: false)
      @game.touch(:updated_at) # force re-broadcast
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@round.game)
      end
    end
  end

  private

  def permitted_params
    params.require(:round).permit(:guess)
  end

  def assign_answer_attributes
    if @game.user_one == current_user
      @round.user_one_answer = @round.guess
    else
      @round.user_two_answer = @round.guess
    end
  end
end
