class AccountActivationsController < ApplicationController

  # Activate a User
  def edit
    user = User.find_by(email: params[:email])		# find user by email
    # if user var exists, user is not already activated, and activation token matches
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate					# call activate method
      log_in user					# login user
      flash[:success] = "Account activated!"		# set flash data
      redirect_to user					# direct to profile page
    else
      flash[:danger] = "Invalid activation link"	# set flash data
      redirect_to root_url				# direct to home page
    end
  end
end
