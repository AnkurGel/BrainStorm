class Image < ActiveRecord::Base
  attr_accessible :image, :level_id, :image_cache

  #mount_uploader :image, ImageUploader
  validates :image, :presence => true
  belongs_to :level
end
