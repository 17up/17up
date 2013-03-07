class OliveController < ApplicationController
	before_filter :authenticate_admin

	def index
		set_seo_meta("Olive",t('keywords'),t('describe'))
	end

	private
  	def authenticate_admin
    	unless current_member and current_member.admin?
      		redirect_to new_member_session_path(:admin => 1)
    	end
  	end

	def photos(provider,title)
		provider.new.tagged(title).map{|x| x[:photo] }
	end
end
