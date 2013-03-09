class Greet

  def initialize(provider, opts={})    
    @provider = provider       
  end
  
  def deliver
    veggie = Authorization.official(@provider.provider)
    case @provider.provider
    when "weibo"  
      client = Weibo::Client.new(veggie.token,veggie.uid) 
      @content = I18n.t('greet.new_user',:name => @provider.at_name)     
      data = client.statuses_update(@content)
    when "twitter"
      client = Twitter::Client.new(
        :oauth_token => veggie.token,
        :oauth_token_secret => veggie.secret
      )
      @content = I18n.t('greet.new_user',:name => @provider.at_name)
      data = client.update(@content)
    when "github"
      github = Github.new oauth_token: veggie.token
      github.users.followers.follow @provider.user_name
    when "tumblr"
      client = Tumblr.new(
        :oauth_token => veggie.token,
        :oauth_token_secret => veggie.secret
      )
      client.follow @provider.metadata["blogs"][0]["url"]
    when "instagram"
      client = Instagram.client(:access_token => veggie.token)
			client.follow_user(@provider.uid)
		when "youtube"
		  
    end    
    if data
      Greet.logger(data['id'].to_s + " send greet success to #{@provider.user_name}")
    end
  end 
  
  def self.logger(msg)
    Logger.new(File.join(Rails.root,"log","greet.log")).info("[#{Time.now.to_s}]" + msg.to_s)
  end
  
end


