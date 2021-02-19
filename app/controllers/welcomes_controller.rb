class WelcomesController < ApplicationController
  def index
    @users = User.where('updated_at > ?', 24.hours.ago)
  end
end
