class UsersController < ApplicationController
  skip_before_action :authenticate!

  def new
    redirect_to welcomes_path if current_user
  end

  def create
    user = User.create!(permitted_params)
    session[:user_id] = user.id

    redirect_to welcomes_path
  end

  def destroy
    user = User.find(params[:id])
    session[:user_id] = nil
    user.destroy!
    redirect_to welcomes_path
  end

  private

  def permitted_params
    params.require(:user).permit(:name)
  end
end
