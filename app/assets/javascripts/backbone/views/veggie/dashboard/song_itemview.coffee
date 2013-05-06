class window.Veggie.SongView extends Backbone.View
	id: "song"
	template: JST['item/song']
	render: ->
		@$el.html @template(@model.toJSON())
		this
	play: ->
		@audio = soundManager.createSound
			id: @model.get("_id")
			url: @model.get("url")
		@audio.play()
		lyrics = new Lrc @model.get("lyrics"),@show_lyrics
		info = lyrics.tags
		lyrics.play(0)
	fade_in: ($txt) ->
		setTimeout( ->
			$txt.css 
				"-webkit-transform":"scale(1) translateY(170px)"
				"opacity": "1"
		,10)		
	fade_out: ($txt) ->
		$txt.css 
			"-webkit-transform":"scale(1.5)"
			"opacity": "0.0"
		$txt.on "webkitTransitionEnd",->
			$(@).remove()
	show_lyrics: (text,ex) ->
		@$el.prepend JST['item/lrc'](text: text)
		$alert = $(".lyrics:first-child",@$el)
		@fade_in($alert)
		@fade_out($alert.siblings())
