class HomeController < ApplicationController

  def index
  	#agent = request.user_agent.downcase
    #if agent.include?("iphone") or agent.include?("android")
    #  	redirect_to $config[:mobile_host]
    #else
    	set_seo_meta(nil,t('keywords'),t('describe'))
    #end
    @num = 5000 - Member.count
  end

end
