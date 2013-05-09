class Song
  	include Mongoid::Document

  	field :lyrics
	field :artist
	field :album
	field :title
	field :format

	validates :title, :uniqueness => true,:presence => true
	validates :lyrics, :presence => true

	AUDIO_URL = "/system/audios/song/"
	AUDIO_PATH = "#{Rails.root}/public" + AUDIO_URL

	def audio_path
		AUDIO_PATH + "#{_id}/#{$config[:name]}." + format if format
	end

	def audio_url
		AUDIO_URL + "#{_id}/#{$config[:name]}." + format if format
	end

	def as_json
		ext = {
			:url => audio_url
		}
		super(:only => [:_id,:lyrics,:artist,:title]).merge(ext)
	end
end
