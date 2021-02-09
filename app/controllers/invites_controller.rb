class InvitesController < ApplicationController
  def create
    invite = Invite.find_or_initialize_by(
      permitted_params.merge(
        from: current_user,
        accepted: nil,
      )
    )
    invite.save!

    flash[:notice] = "Invitation sent"
    redirect_to welcomes_path
  end

  # Accept invitation and create game
  def update
    @invite = Invite.find(params[:id])
    Invite.transaction do
      @invite.update!(permitted_params)

      if @invite.accepted
        if @invite.from.playing
          flash[:error] = "#{@invite.from.name} already started another game. Game cancelled."
        else
          current_user.update!(playing: true)
          @invite.game = Game.new(
            user_one: @invite.from,
            user_two: @invite.to,
          )
          @invite.game.create_rounds!
        end
      end
      redirect_to welcomes_path
    end
  end

  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy!
    redirect_to welcomes_path
  end

  private

  def permitted_params
    params.require(:invite).permit(:to_id, :accepted)
  end
end
