require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper	# provides access to full_title

  # setup a user
  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)					# get the profile page
    assert_template 'users/show'				# confirm the right template
    assert_select 'title', full_title(@user.name)		# confirm the username
    assert_select 'h1', text: @user.name			# confirm the username
    assert_select 'h1>img.gravatar'				# confirm the gravatar
    assert_match @user.microposts.count.to_s, response.body	# count microposts
    assert_select 'div.pagination'				# confirm pagination
    @user.microposts.paginate(page: 1).each do |micropost|	# for each micropost
      assert_match micropost.content, response.body			# confirm content
    end
  end
end
