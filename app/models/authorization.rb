class Authorization
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :provider
  field :uid
  field :token
  field :secret
  field :expired_at, :type => Time
  field :info, :type => Hash

  validates :provider, :presence => true
  validates :uid, :presence => true, :uniqueness => {:scope => :provider}
  belongs_to :member
  after_create :send_greet

  PROVIDERS = %w{twitter weibo github tumblr instagram youtube}

  def avatar(style = :mudium)
    image = info[:image] || info[:avatar]
    case style
    when :mudium
      image
    when :large
      case provider
      when "weibo"
        image.gsub("/50/","/180/")
      when "twitter"
        image.gsub("_normal","")
      when "tumblr"
        image.gsub("_64","_512")
      else
        image
      end
    end
  end

  def send_greet
	if self.member.authorizations.length == 1
	  # 注册 save avatar from provider
	  self.member.save_avatar(avatar(:large))
	end     
    HardWorker::SendGreetJob.perform_async(self._id)
  end

  # @twitter @weibo
  def at_name
    info[:nickname]
  end

  def user_name
    info[:name] || at_name
  end

  def link
    case provider
    when "weibo"
      link = info[:urls][:Weibo]
      link.blank? ? "http://weibo.com/#{uid}" : link
    when "twitter"
      info[:urls][:Twitter]
    when "tumblr"
      info[:blogs][0][:url]
    when "instagram"
      "http://instagram.com/#{at_name}"
    when "github"
      info[:urls][:GitHub]
    when "youtube"
      info[:channel_url]
    end
  end

end
