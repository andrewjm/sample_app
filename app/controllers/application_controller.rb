class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # inclusions here are available in all controllers

  protect_from_forgery with: :exception
  include SessionsHelper	# functions for logging in/out

end
