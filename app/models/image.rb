class Image < ActiveRecord::Base
  attr_accessible :image, :level_id

  mount_uploader :image, ImageUploader
  belongs_to :level
end
