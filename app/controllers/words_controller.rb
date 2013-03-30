class WordsController < ApplicationController
	before_filter :authenticate_member!

	def fetch
		word = Word.where(:title => params[:title]).first
		render_json 0,"ok",word.as_json
	end

end