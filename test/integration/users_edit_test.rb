require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  # Grab dummy user params from fixtures
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)							# log the user in
    get edit_user_path(@user)						# follow link to edit page
    assert_template 'users/edit'					# confirm edit page renders
    patch user_path(@user), user: { name:  "",				# issue a patch with invalid params
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'					# confirm edit page renders on fail
  end

  test "successful edit" do
    log_in_as(@user)							# log the user in
    get edit_user_path(@user)						# follow link to edit page
    assert_template 'users/edit'					# confirm edit page renders
    name  = "Foo Bar"							# set name param
    email = "foo@bar.com"						# set email param
    patch user_path(@user), user: { name:  name,			# issue a patch with valid params
                                    email: email,
                                    password:              "",		# pw left blank bc not necessary
                                    password_confirmation: "" }
    assert_not flash.empty?						# confirm flash is not empty
    assert_redirected_to @user						# confirm redirect to profile page
    @user.reload							# grab new user data from db
    assert_equal @user.name,  name					# confirm new name param is correct
    assert_equal @user.email, email					# confirm new email param is correct
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)						# get edit page before loggin in
    log_in_as(@user)							# log in
    assert_redirected_to edit_user_path(@user)				# confirm a redirect to edit page
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name:  name,
                                    email: email,
                                    password:              "foobar",
                                    password_confirmation: "foobar" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name,  name
    assert_equal @user.email, email
  end
end
