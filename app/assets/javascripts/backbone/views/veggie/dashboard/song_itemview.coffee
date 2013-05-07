class window.Veggie.SongView extends Backbone.View
	id: "song"
	template: JST['item/song']
	events:
		"click .back": "back"
	back: ->
		@model.set 
			open: false
		@$el.siblings().show()
		@$el.parent().siblings().show()
	initialize: ->
		@listenTo(@model, 'change', @render)
	render: ->
		@$el.html @template(@model.toJSON())
		this
	play: ->
		Veggie.hide_nav()
		@$el.parent().siblings().hide()
		@$el.siblings().hide()
		@model.set 
			open: true
		unless @audio
			@audio = soundManager.createSound
				id: @model.get("_id")
				url: @model.get("url")
				autoLoad: true
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
