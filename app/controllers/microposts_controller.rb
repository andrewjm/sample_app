class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]	# must be logged in to create or destroy
  before_action :correct_user,   only: :destroy

  # create a micropost
  def create
    @micropost = current_user.microposts.build(micropost_params)	# build the micropost
    if @micropost.save
      flash[:success] = "Micropost created!"				# set flash data
      redirect_to root_url						# direct to home page
    else
      @feed_items = []					# the feed partial needs something or it will break
      render 'static_pages/home'					# else render home page
    end
  end

  # Delete a micropost
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url	# redirect to home page or the last url (referrer)
  end

  private

    # Create strong parameters
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    # Confirm correct user for micropost
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
