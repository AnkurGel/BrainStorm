class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  scope :with_rank, lambda { |rank| order('score DESC').offset(rank - 1).limit(1) }
  before_create :allot_score
  before_update :verify_college
  # And allot "Others" to college if blank or 0
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider,
                  :uid, :name, :image, :college_id, :link

  # attr_accessible :title, :body
  validates :name, :presence => true , :length => { :maximum => 25 },
    :format => { :with => /^[A-Za-z ]+$/, :message => ": Err.. Your name should only contain alphabets, dear."}


  has_many :attempts, :dependent => :destroy
  belongs_to :college
  accepts_nested_attributes_for :college

  validates_associated :college
  def self.find_or_create(auth, signed_in_resource=nil)
    new_record = false
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      new_record = true
      user = User.create(provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         name: auth.info.name,
                         password:Devise.friendly_token[0,20],
#                         college:college_name,
                         :image => auth.info.image,
                         :link => auth.extra.raw_info.link
                         )
    end
    [user, new_record]
  end

  private
  def allot_score
    self.score = 1
  end
  def verify_college
    if self.college.nil?
      self.college = College.find_by_name("Other") if College.find_by_name("Other")
    end
  end

  def self.registration_data
    registrations = select('DATE(created_at) date, count(id) as total_ids').group("DATE(created_at)")
    registrations.map do |x|
      { date: x.date, total_ids: x.total_ids }
    end
  end

  def self.colleges_bar_chart_data
    users = group('college_id').select('count(id) as id,
                                       college_id,
                                       MAX(score) as score,
                                       SUM(sign_in_count) as signins').order('id DESC, score DESC,
                                                                             signins DESC').limit(10)
    users.map do |user|
      { id: user.id,
        college: if user.college then College.find(user.college_id).try(:name) end,
        score: user.score,
        signins: user.signins
      }
    end
  end

  def self.fb_non_fb_users_data
    fb_users = where('provider = ?', 'facebook')
    non_fb_users = where(:provider => nil)
    [ { label: "Facebook Registrations", value: fb_users.count },
      { label: "Site Registrations", value: non_fb_users.count }
    ]
  end
end
