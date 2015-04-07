class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])		# get the user to be followed
    current_user.follow(@user)				# create a relationship btwn current user and other
    respond_to do |format|				# handle Ajax request
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed	# get the user to be unfollowed
    current_user.unfollow(@user)			# destroy relationship btwn current user and other
    respond_to do |format|				# handle Ajax request
      format.html { redirect_to @user }
      format.js
    end
  end

end
