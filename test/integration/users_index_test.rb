require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin 	= users(:michael)
    @non_admin 	= users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)							# login at admin
    get users_path							# goto users index page
    assert_template 'users/index'					# confirm template
    assert_select 'div.pagination'					# confirm pagination is there
    first_page_of_users = User.paginate(page: 1)			# put the 30 returned users into var
    first_page_of_users.each do |user|					# iterate over each user
      assert_select 'a[href=?]', user_path(user), text: user.name	# confirm href and name
      unless user == @admin						# if not admin
        assert_select 'a[href=?]', user_path(user), text: 'delete',	# confirm delete is present
                                                    method: :delete
      end
    end
    assert_difference 'User.count', -1 do				# confirm 1 user was deleted
      delete user_path(@non_admin)					# delete the user
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)						# login as non admin
    get users_path							# goto users index page
    assert_select 'a', text: 'delete', count: 0				# confirm delete is not present
  end
end
