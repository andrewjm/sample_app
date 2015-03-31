class PasswordResetsController < ApplicationController
  before_action :get_user,   		only: [:edit, :update]
  before_action :valid_user, 		only: [:edit, :update]
  before_action :check_expiration,	only: [:edit, :update]

  def new
  end

  # Initiate a password reset
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)	# find user by email
    if @user
      @user.create_reset_digest							# create a reset digest
      @user.send_password_reset_email						# send reset email
      flash[:info] = "Email sent with password reset instructions"		# set flash data
      redirect_to root_url							# direst to home page
    else
      flash.now[:danger] = "Email address not found"				# set flash data
      render 'new'								# call new method
    end
  end

  def edit
  end

  # Reset Password
  def update
    if password_blank?					# check it pw is blank
      flash.now[:danger] = "Password can't be blank"	# set flash data
      render 'edit'					# show edit page
    elsif @user.update_attributes(user_params)		# check update password
      log_in @user					# log in user
      flash[:success] = "Password has been reset."	# set flash data
      redirect_to @user					# direct to user profile
    else
      render 'edit'					# show edit page
    end
  end

  private

    # To organize pw and pw confirmation into one object
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # Returns true if password is blank.
    def password_blank?
      params[:user][:password].blank?
    end

    def get_user
      @user = User.find_by(email: params[:email])		# grab the user by email
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&			# check if user exists, is activated
              @user.authenticated?(:reset, params[:id]))	# and is authenticated
        redirect_to root_url					# direct to home page
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
