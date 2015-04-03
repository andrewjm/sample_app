class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy			# one to many, user to posts
								# post dep on user, no user no posts

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor	:remember_token, :activation_token, :reset_token

  before_save	:downcase_email
  before_create	:create_activation_digest

  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
		    format: { with: VALID_EMAIL_REGEX },
		    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true	# allow blank is for profile edits.
									# has_secure_password requires a pw
									# on object creation.

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)			# attr = remember || activation
    digest = send("#{attribute}_digest")		# interpolate the proper digest
    return false if digest.nil?				# check digest existance
    BCrypt::Password.new(digest).is_password?(token)	# ... what does this do exactly?
  end

    # Version 3
    # def authenticated?(attribute, token)
    #   digest = self.send("#{attribute}_digest")
    #   return false if digest.nil?
    #   BCrypt::Password.new(digest).is_password?(token)
    # end

    ## Version 2
    # def authenticated?(remember_token)
    #   digest = self.send('remember_digest')
    #   return false if digest.nil?
    #   BCrypt::Password.new(digest).is_password?(remember_token)
    # end

    ## Version 1
    # def authenticated?(remember_token)
    #   return false if remember_digest.nil?
    #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
    # end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)		# update the attr in db
    update_attribute(:activated_at, Time.zone.now)	# note time of activation
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now	# send user activation email
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token					# set new token
    update_attribute(:reset_digest,  User.digest(reset_token))		# save reset digets to db
    update_attribute(:reset_sent_at, Time.zone.now)			# take note of creation time
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now				# send reset email
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago		# check if reset was sent more than 2 hours ago
  end					# seems opposite, but consider Unix Time as represented as an ing

  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    Micropost.where("user_id = ?", id)	# ? escapes the SQL query
  end

  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
