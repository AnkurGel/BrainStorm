class Level < ActiveRecord::Base
  attr_accessible :answer, :next_id, :prev_id, :question, :images_attributes

  validates :question, :presence => true
  validates :answer, :presence => true, :length => { :maximum => 20 }

  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true

  def self.set(params)
    next_id = nil
    prev_id = (Level.last and Level.last.id) ? Level.last.id : nil
    params[:prev_id] = prev_id
    level = Level.new(params)
    level
  end
  def new?
    true unless self.id
  end
end
