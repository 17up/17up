module HardWorker
  class Base
    include Sidekiq::Worker
    sidekiq_options retry: false 
    
    def logger(msg)
      Logger.new(File.join(Rails.root,"log","sidekiq-job.log")).info("[#{self.class}] #{msg}")
    end
  end
    
  class SendGreetJob < Base          
    def perform(id, opts={})
      provider = Authorization.find(id)
      self.logger(provider.user_name)
      Greet.new(provider,opts).deliver
    end
  end
  
  class UploadOlive < Base
    def perform(content,pic)
      begin
        provider = Authorization.official("weibo")
        client = Weibo::Client.new(provider.token,provider.uid)
        data = client.statuses_upload(content,pic)
				msg = data["error_code"] ? data.to_s : "#{data["id"]} published"
				self.logger msg
      rescue => ex
        self.logger("#{content} [#{pic}] fail msg: #{ex.to_s}")
      end
      #twitter
      veggie = Authorization.official("twitter")
      client = Twitter::Client.new(
        :oauth_token => veggie.token,
        :oauth_token_secret => veggie.secret
      )
      client.update_with_media(content,File.open(pic))
    end
  end
  
end
