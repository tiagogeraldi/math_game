class WelcomesController < ApplicationController
  def index
    if current_user
      @users = User.where("updated_at > ?", 24.hours.ago)
    else
      redirect_to new_user_path
    end
  end
end
