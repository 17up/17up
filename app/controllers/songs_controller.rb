class SongsController < ApplicationController
	before_filter :authenticate_member!

	def create
		p params.slice(:artist,:title,:album)
		#song = Song.new(:artist => params[:artist])
		render_json 0,"ok"#,song.to_json
	end

	def upload
		file = params[:file]
	end

end