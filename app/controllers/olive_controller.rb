class OliveController < ApplicationController
	before_filter :authenticate_admin

	def index
		set_seo_meta("Olive",t('keywords'),t('describe'))
	end

	def quotes
		data = {
			:tags => {
				:count => Quote.tags.count,
				:top => Quote.tags_list.reverse[0..19]
			},
			:quotes => []
		}
		render_json 0,'ok',data
	end

	# single tag
	def destroy_tag
		@quotes = Quote.where(:tags => params[:tag]) 
		count = @quotes.count
		if count != 0
			@quotes.each do |q|
				q.tags.delete params[:tag]
				q.save
			end
			Quote.tags_list(:pop => params[:tag])
		end
		render_json 0,'ok',count
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
