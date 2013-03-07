class Attempt < ActiveRecord::Base
  attr_accessible :attempt, :level_id, :user_id

  scope :group_by_level, lambda{ group(:level_id).select('level_id, count(id) as total_attempts') }

  validates :attempt,   :presence => true, :uniqueness => {
    :scope => [:user_id, :level_id], :message => "should only be used once",
    :case_sensitive => false }
  #a case-insensitive attempt must be unique among a particular user
  #at a specified level.

  belongs_to :user
  belongs_to :level

  def self.level_attempt_chart_data(current_user)
    level_attempts = group_by_level
    top_user = where('user_id = ?', User.with_rank(1)).group_by_level
    second_user = where('user_id = ?', User.with_rank(2)).group_by_level
    third_user = where('user_id = ?', User.with_rank(3)).group_by_level
    current_user_attempts = where('user_id = ?', current_user).group_by_level

    level_attempts.map do |la|
      {
        level_id: la.level_id,
        total_attempts: la.total_attempts,
        top_user_attempts: top_user.where('level_id = ?', la.level_id).first.try(:total_attempts) || 0,
        second_user_attempts: second_user.where('level_id = ?', la.level_id).first.try(:total_attempts) || 0,
        third_user_attempts: third_user.where('level_id = ?', la.level_id).first.try(:total_attempts) || 0,
        current_user_attempts: current_user_attempts.where('level_id = ?', la.level_id).first.try(:total_attempts) || 0
      }
    end
  end
end
