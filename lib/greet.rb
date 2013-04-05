class Greet
	include Utils::Service

  def initialize(provider, opts={})    
		@provider = provider       
  end
  
  def deliver
  	content = I18n.t('greet.new_user',:name => @provider.at_name)  
		case @provider.provider
		when "weibo"  		     
		  data = client(true).statuses_update(content)
		when "twitter"
		  data = client(true).update(content)
		when "github"
		  client(true).users.followers.follow @provider.user_name
		when "tumblr"
		  client(true).follow @provider.metadata["blogs"][0]["url"]
		when "instagram"
			client(true).follow_user(@provider.uid)
		when "youtube"
			client(true).subscribe_channel(@provider.user_name)
		end    
		if data
			Greet.logger(data['id'].to_s + " send greet success to #{@provider.user_name}")
		end
  end 

  def client(official = false)
  	auth = @provider
  	if official
  		auth = Authorization.official(@provider.provider)
  	end
  	case auth.provider
		when "weibo"  
			client = Weibo::Client.new(auth.token,auth.uid) 
		when "twitter"
		  client = Twitter::Client.new(
				:oauth_token => auth.token,
				:oauth_token_secret => auth.secret
		  )
		when "github"
		  client = Github.new oauth_token: auth.token
		when "tumblr"
		  client = Tumblr.new(
				:oauth_token => auth.token,
				:oauth_token_secret => auth.secret
		  )
		when "instagram"
			client = Instagram.client(:access_token => auth.token)
		when "youtube"
			key = load_service["youtube"]["app_key"]
			client = YouTubeIt::OAuth2Client.new(
				client_access_token: auth.token, 
				client_refresh_token: auth.refresh_token, 
				client_id: "17up.org", 
				client_secret: auth.secret, 
				dev_key: key,
				client_token_expires_at: auth.expired_at.to_i.to_s)
			#client.refresh_access_token!
		end
		
  end
  
  def self.logger(msg)
		Logger.new(File.join(Rails.root,"log","greet.log")).info("[#{Time.now.to_s}]" + msg.to_s)
  end
  
end


