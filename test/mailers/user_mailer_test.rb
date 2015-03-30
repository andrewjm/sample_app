require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)					# set a user from fixtures
    user.activation_token = User.new_token			# create an activation token for user
    mail = UserMailer.account_activation(user)			# create mail object
    assert_equal "Account activation", mail.subject		# check subject line
    assert_equal [user.email], mail.to				# check recipient email address
    assert_equal ["noreply@example.com"], mail.from		# check from address
    assert_match user.name,               mail.body.encoded	# check user name is in body
    assert_match user.activation_token,   mail.body.encoded	# check activation token is in body
    assert_match CGI::escape(user.email), mail.body.encoded	# check for escaped user email
  end

  test "password_reset" do
    mail = UserMailer.password_reset
    assert_equal "Password reset", mail.subject
    assert_equal ["to@example.org"], mail.to
#    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
