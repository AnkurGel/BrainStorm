class Level < ActiveRecord::Base
  attr_accessible :answer, :next_id, :prev_id, :question, :images_attributes, :hint, :alt, :title, :extra_content
  before_save :sterlize_answer

  validates :answer, :presence => true, :length => { :maximum => 20 }

  has_many :images, :dependent => :destroy
  has_many :attempts
  accepts_nested_attributes_for :images, :allow_destroy => true

  validates_associated :images
  def self.set(params)
    next_id = nil
    prev_id = (Level.last and Level.last.id) ? Level.last.id : nil
    params[:prev_id] = prev_id
    level = Level.new(params)
    level
  end

  private
  def sterlize_answer
    self.answer = self.answer.chomp.downcase.gsub(/[\W\n\s]/,'')
  end

end
