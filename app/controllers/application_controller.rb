class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # inclusions here are available in all controllers

  protect_from_forgery with: :exception
  include SessionsHelper	# functions for logging in/out

  private

    # Confirms a logged-in user.
    # placing this in app_controller makes it accessible to both user and micropost controllers
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

end
