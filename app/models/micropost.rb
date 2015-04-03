class Micropost < ActiveRecord::Base
  belongs_to :user						# one to one, post to user
  default_scope -> { order(created_at: :desc) }			# order posts from newest to oldest
  mount_uploader :picture, PictureUploader	# tell CarrierWave to associate the image w the model
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size		# validate a custom defined check

  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
