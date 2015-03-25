class SessionsController < ApplicationController
  def new
  end

  # Create a session
  def create
    user = User.find_by(email: params[:session][:email].downcase) # grab user object from db by form email
    if user && user.authenticate(params[:session][:password])	  # try authenticating by form pw
      log_in user		# log_in lives in app/helpers/sessions_helper.rb
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) # remember is permanent cookie
      redirect_to user		# rails converts user to user_url(user)
    else
      flash.now[:danger] = 'Invalid email/password combination' # flash error message on invalid login
								# flash.now disappears on any new request
      render 'new'
    end
  end

  # Delete the session
  def destroy
    log_out if logged_in?	# log_out lives in app/helpers/sessions_helper.rb
    redirect_to root_url	# redirect to homepage
  end
end
