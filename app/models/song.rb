class Song
  	include Mongoid::Document

  	field :lyrics
	field :artist
	field :album
	field :title
	field :info, type: Hash

	AUDIO_URL = "/system/audios/song/"
	AUDIO_PATH = "#{Rails.root}/public" + AUDIO_URL

	def audio_path
		AUDIO_URL + "#{_id}/#{$config[:name]}." + info[:format]
	end

	def as_json
		ext = {
			:url => audio_path
		}
		super(:only => [:_id,:lyrics,:artist,:title]).merge(ext)
	end
end
