class SessionsController < ApplicationController
  def new
  end

  # Create a session
  def create
    user = User.find_by(email: params[:session][:email].downcase) # grab user object from db by form email
    if user && user.authenticate(params[:session][:password])	  # try authenticating by form pw
      if user.activated?			# check if user is activated
        log_in user				# login user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user) # set temp or permanent cookie
        redirect_back_or user			# exectues friendly forwarding or redirect to default
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message		# set flash data
        redirect_to root_url			# direct to home page
      end
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
