require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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

  test "valid signup information" do				# name test
    get signup_path						# test signup renders
    assert_difference 'User.count', 1 do			# look for difference of 1 in User.count after 'do'
      post_via_redirect users_path, user: { name:  "Example User",	# post true user params & follow redirect
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'users/show'				# check users/show renders successful signup
  end

end
