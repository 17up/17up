class MobileController < ApplicationController
  
  def index
    set_seo_meta(t('mobile.title'),t('keywords'),t('describe'))
  end

  def lab
  	set_seo_meta(nil)
  	@pics = Olive::Tumblr.new(Authorization.official("tumblr")).user_liked_media
  end

end
