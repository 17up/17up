class Member
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:weibo,:twitter,:github,:tumblr,:instagram,:youtube]

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Token authenticatable
  # field :authentication_token, :type => String

  field :role 
  field :uid
  field :gem, :type => Integer, :default => 0

  has_many :authorizations,:dependent => :destroy
  has_many :courses
  embeds_many :course_grades
  accepts_nested_attributes_for :course_grades

  validates :uid, :uniqueness => true,
                  :allow_blank => true,
                  :length => {:in => 2..20 },
                  :format => {:with => /^[A-Za-z0-9_]+$/ }

  after_destroy :clear_data

  AVATAR_URL = "/system/images/member/"
  AVATAR_PATH = "#{Rails.root}/public"+AVATAR_URL
  AVATAR_SIZE_LIMIT = 3000*1000 #3m
  ## role 用户组别 
  ROLE = %w{a u t}
  # nil 三无用户，被清理对象
  scope :x, where(:role => nil)
  ROLE.each do |r|
    scope r.to_sym,where(:role => r)
  end
  
  def admin?
    self.role == "a"
  end
  
  def is_member?
    !role.blank?
  end

  def course_list
    cids = course_grades.pluck(:course_id)
    Course.where(:_id.in => cids)
  end

  def member_path
    "#{role}/#{uid}"
  end

  def avatar
    File.exist?(AVATAR_PATH + avatar_name) ? (AVATAR_URL + avatar_name) : "icon/avatar.jpg"
  end

  def avatar_name
    "#{_id}/#{c_at.to_i}.jpg"
  end

  def validate_upload_avatar(file,type)
    type.scan(/(jpeg|png|gif)/).any? and File.size(file) < AVATAR_SIZE_LIMIT
  end
  
  def name
    p = self.authorizations.first
    p ? p.user_name : $config[:author]
  end
  
  def has_provider?(p)
    self.authorizations.where(:provider => p).first
  end

  def save_avatar(file_path)
    `mkdir -p #{AVATAR_PATH + _id}`
    # data = open(file_path){|f|f.read}
    # file = File.open(AVATAR_PATH + avatar_name,"wb") << data
    # file.close
    img = MiniMagick::Image.open(file_path)
    img.resize("120x120")
    img.write(AVATAR_PATH + avatar_name)
  end

  def bind_service(omniauth, expires_time)
    self.authorizations.create!(
      provider:     omniauth.provider,
      uid:          omniauth.uid,
      token: omniauth.credentials.token,
      secret: omniauth.credentials.secret,
      info: omniauth.info,
      expired_at: expires_time
    )
  end

  def self.generate(prefix = Utils.rand_passwd(7,:number => true))
    email = prefix + "@" + $config[:domain]
    passwd = Utils.rand_passwd(8)
    user = Member.new(
      :email => email,
      :password => passwd,
      :password_confirmation => passwd)
    if user.save!
      user
    else
      self.generate(prefix + "v")
    end
  end

  def clear_data
    `rm -rf #{AVATAR_PATH + _id}`
  end 

  rails_admin do
    field :email do
      pretty_value do
        bindings[:view].image_tag(bindings[:object].avatar)
      end
      column_width 55
    end
    field :uid
    field :role
    field :gem
    field :c_at
    field :authorizations
  end

  #mongo index
  index({role: 1,uid: 1},{ unique: true })
end
