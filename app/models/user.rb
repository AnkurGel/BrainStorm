class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  scope :with_rank, lambda { |rank| order('score DESC, last_correct_answer_at ASC').offset(rank - 1).limit(1) }
  before_create :allot_score
  before_update :verify_college
  # And allot "Others" to college if blank or 0
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider,
                  :uid, :name, :image, :college_id, :link, :oauth_token, :oauth_expires_at

  # attr_accessible :title, :body
  validates :name, :presence => true , :length => { :maximum => 35 },
    :format => { :with => /^[A-Za-z ]+$/, :message => ": Err.. Your name should only contain alphabets, dear."}


  has_many :attempts, :dependent => :destroy
  belongs_to :college
  accepts_nested_attributes_for :college

  validates_associated :college
  def self.find_or_create(auth, signed_in_resource=nil)
    new_record = false

    user = where(:provider => auth.provider, :uid => auth.uid)
    new_record = true if user.empty?
    new_user = where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.image = auth.info.image
      user.link = auth.extra.raw_info.link
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
    #blocking_registrations
    if new_record
      user.first.destroy
      new_user = User.new
    end
    #block_code end
    [new_user, new_record]
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  def has_publish_permission?
    provider == "facebook" && facebook.get_connection("me", "permissions").first.has_key?("publish_stream")
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
