class ApplicationController < ActionController::Base
  before_action :authenticate!
  helper_method :current_user

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  private

  def authenticate!
    unless current_user
      redirect_to new_user_path
    end
  end
end
