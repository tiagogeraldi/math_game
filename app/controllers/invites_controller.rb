class InvitesController < ApplicationController
  def create
    invite = Invite.find_or_initialize_by(
      permitted_params.merge(
        from: current_user,
        accepted: nil,
      )
    )
    invite.save!

    redirect_to welcomes_path
  end

  # Accept invitation and start game
  def update
    @invite = Invite.find(params[:id])
    Invite.transaction do
      @invite.update!(permitted_params)
      
      if @invite.accepted
        if @invite.from.playing
          flash[:error] = "#{@invite.from.name} already started another game. Game cancelled."
        else
          #current_user.update!(playing: true)
          game = Game.create!(
            user_one: @invite.from,
            user_two: @invite.to,
            user_two_ready: true,
          )
        end
      end    
      redirect_to welcomes_path
    end
  end

  private

  def permitted_params
    params.require(:invite).permit(:to_id, :accepted)
  end
end
