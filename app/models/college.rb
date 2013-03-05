class College < ActiveRecord::Base
  before_save { self.name = self.name.split.map(&:capitalize).join(' ') }
  attr_accessible :name

  validates :name, :presence => true, :uniqueness => true
  has_many :users
end
