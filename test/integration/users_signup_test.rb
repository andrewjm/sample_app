require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear				# clear email deliveries
  end

  test "invalid signup information" do				# name test
    get signup_path						# test signup renders
    assert_no_difference 'User.count' do			# compare User.count before and after
      post users_path, user: { name:  "",			# post false user params
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'					# check users/new renders on failed signup
  end

  test "valid signup information with account activation" do
    get signup_path							# get sign up page
    assert_difference 'User.count', 1 do				# confirm one more user after:
      post users_path, user: { name:  "Example User",			# issue POST req with user data
                               email: "user@example.com",
                               password:              "password",
                               password_confirmation: "password" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size			# confirm exactly 1 email was sent
    user = assigns(:user)						# allow access to instance var
    assert_not user.activated?						# confirm user not activated
    # Try to log in before activation.
    log_in_as(user)							# try to login user
    assert_not is_logged_in?						# confirm not logged in
    # Invalid activation token
    get edit_account_activation_path("invalid token")			# invalid activation token
    assert_not is_logged_in?						# confirm not logged in
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')	# valid token invalid email
    assert_not is_logged_in?							# confirm not logged in
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)	# valid token valid email
    assert user.reload.activated?						# confirm activation
    follow_redirect!							# follow redirect to profile page
    assert_template 'users/show'					# confirm profile page
    assert is_logged_in?						# confirm logged in
  end

end
