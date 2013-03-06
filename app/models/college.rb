class College < ActiveRecord::Base

  attr_accessible :name

  validates :name, :presence => true, :uniqueness => { :case_sensitive => 'false' }
  has_many :users
end
