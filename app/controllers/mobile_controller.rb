class MobileController < ApplicationController
  
  def index
    set_seo_meta(t('mobile.title'),t('keywords'),t('describe'))
  end

end
