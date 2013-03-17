class OliveController < ApplicationController
	before_filter :authenticate_admin

	def index
		set_seo_meta("Olive",t('keywords'),t('describe'))
	end

	def quotes
		data = {
			:tags => Quote.tags_list.sample(77),
			:quotes => []
		}
		render_json 0,'ok',data
	end

	def destroy_tag
		@quotes = Quote.tag_by params[:tag]
		@quotes.each do |q|
			q.tags = q.tags - [params[:tag]]
			q.save
		end
		render_json 0,'ok'
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
