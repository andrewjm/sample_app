require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  # setup test
  def setup
    @user = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)				# goto user profile
    assert_not @user.following.empty?				# confirm user is following others
    assert_match @user.following.count.to_s, response.body	# confirm number following matches db
    @user.following.each do |user|				# confirm href to each followed exists
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "should follow a user the standard way" do
    assert_difference '@user.following.count', 1 do		# confirm difference of 1
      post relationships_path, followed_id: @other.id		# issue POST request with other.id
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do		# confirm difference of 1
      xhr :post, relationships_path, followed_id: @other.id	# issue XHR POST request with other.id
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end
