require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

  # setup a micropost
  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do		
    assert_no_difference 'Micropost.count' do			# confirm no post created
      post :create, micropost: { content: "Lorem ipsum" }	# try to create a post
    end
    assert_redirected_to login_url				# confirm redirect to login page
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do			# confirm no post deleted
      delete :destroy, id: @micropost				# try to delete a post
    end
    assert_redirected_to login_url				# confirm redirect to login page
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end
end
