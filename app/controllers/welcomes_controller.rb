class WelcomesController < ApplicationController
  def index
    if current_user
      @users = User.all
    else
      redirect_to new_user_path
    end
  end
end
