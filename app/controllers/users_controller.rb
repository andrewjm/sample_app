class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])	# pass the id parameter to find()
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) 
    if @user.save
      flash[:success] = "Welcome to the Sample App!"	# if successful, print msg only on first visit
      redirect_to @user	# redirect_to is convention over 'render'
			# in this case @user == user_url(@user)
    else
      render 'new'
    end
  end

  private

    # STRONG PARAMETERS
    # user_params requires attribute user, and within it permits attri
    # butes name, email, password, password_confirmation
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

end
