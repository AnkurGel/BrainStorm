class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  before_save :allot_score
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider,
                  :uid, :college

  # attr_accessible :title, :body

  def self.find_or_create(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    college_name = auth.extra.raw_info.education.last.school.name ? auth.extra.raw_info.education.last.school.name : ""
    unless user
      user = User.create(provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20],
                         college:college_name
                         )
    end
    user
  end

  private
  def allot_score
    self.score = 0
  end
end
