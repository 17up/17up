class WordsController < ApplicationController
	before_filter :authenticate_member!

	def fetch
		word = Onion::Word.new(params[:title]).insert(:skip_exist => 1)
		if @uw = current_member.has_u_word(word)
			word = @uw
		end
		render_json 0,"ok",word.as_json
	end

	def imagine
		synsets = Onion::Word.wordnet(params[:title],:synset)
		synsets.delete(params[:title])
		render_json 0,"ok",synsets
	end

	# U Word
	# 用户上传图片
  	# upload &image &id
  	# response with js.haml
	def upload_img_u
	    @uw = find_or_create_uw(params[:_id])
		file = params[:image].tempfile.path
	    type = params[:image].content_type
		if @uw&&@uw.validate_upload_image(file,type)
    		@uw = @uw.make_image(file)
    		@uw.img_info = params[:info]
    		@uw.save
			img = @uw.image_url + "?#{Time.now.to_i}"
			render_json 0,t("flash.success.upload.uword"),img
		else
			render_json -1,"error"
		end	
	end

	# U word
	# 个人发音,自动上传
    def upload_audio_u
	    @uw = find_or_create_uw(params[:_id])
	    file = params[:file]
	    @store_path = UWord::AUDIO_PATH + "#{@uw._id}"
	    unless File.exist?(@store_path)
	      `mkdir -p #{@store_path}`
	    end
	    # 压缩成 ogg
	    `oggenc -q 4 #{file.tempfile.path} -o #{@uw.audio_path}`
	    render_json 0,"ok"
	end

	private
	  def find_or_create_uw(id)
	    @word = Word.find(id)
	    unless @uw = current_member.has_u_word(@word)
	      @uw = current_member.u_words.create(:word_id => @word._id)
	    end
	    @uw
	  end

end