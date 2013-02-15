class Attempt < ActiveRecord::Base
  attr_accessible :attempt, :level_id, :user_id

  validates :attempt,   :presence => true, :uniqueness => {
    :scope => [:user_id, :level_id], :message => "should only be used once",
    :case_sensitive => false }
  #a case-insensitive attempt must be unique among a particular user
  #at a specified level.

  belongs_to :user
  belongs_to :level
end
