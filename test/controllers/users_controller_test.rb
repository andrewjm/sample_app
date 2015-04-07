require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  # fill with dummy user data from fixtures
  def setup
    @user	= users(:michael)	# setup user 1
    @other_user	= users(:archer)	# setup user 2
  end

  test "should redirect index when not logged in" do
    get :index						# get index action
    assert_redirected_to login_url			# confirm a redirect to login page
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user				# issue a get request to :edit under @user
    assert_not flash.empty?				# confirm flash is not empty
    assert_redirected_to login_url			# confirm a redirect to login page
  end

  test "should redirect update when not logged in" do
    # issue a patch request to :update under @user
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?				# confirm flash is not empty
    assert_redirected_to login_url			# confirm a redirect to login page
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)		# login as @other_user
    get :edit, id: @user		# issue a get request to :edit under @user
    assert flash.empty?			# confirm flash is not empty
    assert_redirected_to root_url	# confirm a redirect to root url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)		# login as @other_user
    # issue a patch request to :update under @user
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?			# confirm flash is not empty
    assert_redirected_to root_url	# confirm a recirect to root url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do		# confirm no user is deleted
      delete :destroy, id: @user			# try to delete a user
    end
    assert_redirected_to login_url			# confirm a redirect to login page
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)				# login as non admin user
    assert_no_difference 'User.count' do		# confirm no user is deleted
      delete :destroy, id: @user			# try to delete a user
    end
    assert_redirected_to root_url			# confirm a redirect to login page
  end

  test "should redirect following when not logged in" do
    get :following, id: @user
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get :followers, id: @user
    assert_redirected_to login_url
  end

end
