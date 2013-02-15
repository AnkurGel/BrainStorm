class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  before_create :allot_score
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider,
                  :uid, :college, :name, :image

  # attr_accessible :title, :body
  validates :name, :presence => true , :length => { :maximum => 25 },
    :format => { :with => /^[A-Za-z ]+$/, :message => ": Err.. Your name should only contain alphabets, dear."}
  validates :college, :length => { :maximum => 60 }

  has_many :attempts, :dependent => :destroy
  def self.find_or_create(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    college_name = auth.extra.raw_info.education.last.school.name ? auth.extra.raw_info.education.last.school.name : ""
    unless user
      user = User.create(provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         name: auth.info.name,
                         password:Devise.friendly_token[0,20],
                         college:college_name,
                         :image => auth.info.image
                         )
    end
    user
  end

  private
  def allot_score
    self.score = 1
  end
end
