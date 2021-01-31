class UsersController < ApplicationController
  def create
    user = User.create!(permitted_params)
    session[:user_id] = user.id

    redirect_to welcomes_path
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!
    session[:user_id] = nil
    redirect_to welcomes_path
  end

  private

  def permitted_params
    params.require(:user).permit(:name)
  end
end
