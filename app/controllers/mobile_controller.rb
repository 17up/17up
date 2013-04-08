class MobileController < ApplicationController
  caches_page :index
  
  def index
    set_seo_meta(t('mobile.title'),t('keywords'),t('describe'))
  end

end
