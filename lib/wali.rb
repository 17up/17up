module Wali	
	class Base
		include Utils::Service
		include ActionView::Helpers::SanitizeHelper

		def initialize(provider, opts={})    
			@provider = provider       
	  	end

	  	def client(auth = nil)
	  		unless auth and auth.class == Authorization
		  		auth = @provider
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

	  	def logger(msg)
			Logger.new(File.join(Rails.root,"log","wali.log")).info(self.class.to_s + " [#{Time.now.to_s}] " + msg.to_s)
	  	end

	end

	class Greet < Base

		def get_time
			h = Time.now.hour
			if h < 4
				"midn"
			elsif h < 8
				"morn"
			elsif h < 12
				"am"
			elsif h < 18
				"pm"
			elsif h < 22
				"night"
			else
				"midn"
			end
		end
  
	  	def deliver
	  		content = I18n.t("greet.new_user.#{get_time}",:name => @provider.at_name) 
	  		veggie = Authorization.official(@provider.provider) 
			case @provider.provider
			when "weibo"  		     
			  data = client(veggie).statuses_update(content)
			when "twitter"
			  data = client(veggie).update(content)
			when "github"
			  client(veggie).users.followers.follow @provider.at_name
			when "tumblr"
			  client(veggie).follow @provider.metadata["blogs"][0]["url"]
			when "instagram"
				client(veggie).follow_user(@provider.uid)
			when "youtube"
				client(veggie).subscribe_channel(@provider.user_name)
			end    
			if data
				logger(data['id'].to_s + " send greet success to #{@provider.user_name}")
			end
	  	end 
	  
	end

	# only weibo
	class Friend < Base

		def bilateral
			friends = client.friendships_friends_bilateral(@provider.uid)["users"]
			friends.collect do |x| 
				x.slice("id","screen_name","name","profile_image_url")
			end
		end

		def twitter
			client.friend_ids.ids & client.follower_ids.ids
		end


	end
	
end


