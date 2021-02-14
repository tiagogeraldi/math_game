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

  def update
    @invite = Invite.find(params[:id])
    Invite.transaction do
      @invite.assign_attributes(permitted_params)
      set_ready
      @invite.save!
      if @invite.ready?
        GameGenerator.new(@invite).run! unless @invite.game
        redirect_to @invite.game
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(@invite)
          end
        end
      end
    end
  end

  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy!
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@invite)
      end
    end
  end

  private

  def set_ready
    return unless @invite.i_am_ready
    if current_user == @invite.from
      @invite.from_ready = true
    else
      @invite.to_ready = true
    end
  end

  def permitted_params
    params.require(:invite).permit(:to_id, :accepted, :i_am_ready)
  end
end
