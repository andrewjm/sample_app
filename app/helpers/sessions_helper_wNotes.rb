module SessionsHelper

  # logs in the given user
  def log_in(user)
    session[:user_id] = user.id	# place temp cookie on client browser containing encrypted user id.
				# used to retrieve user on new page loads. expires on browser close.
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember						# generate remember_token and save to db
    cookies.permanent.signed[:user_id] = user.id		# permanent means expire in 20 years
    cookies.permanent[:remember_token] = user.remember_token	##  signed means encrypted
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])			# not a comparison, if a is true when set to b
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # returns the current logged-in user (if any)
  def current_user
    # if current user is nil, call find_by to db, else set to itself (or leave alone)
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)	# remove user_id from session
    @current_user = nil		# set current user to nil
  end
end
