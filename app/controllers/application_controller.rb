class ApplicationController < ActionController::Base
  private

  def current_user
    # Replace this line with the logic to find the current user
    User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
