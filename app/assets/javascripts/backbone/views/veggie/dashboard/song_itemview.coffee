class window.Veggie.SongView extends Backbone.View
	id: "song"
	template: JST['item/song']
	events:
		"click .back": "back"
		"click .play": "enter"
	back: (e) ->
		@$el.siblings().show()
		@$el.parent().siblings().show()
		$(".banner",@$el).css "width":"50%"
		$(e.currentTarget).hide()
	initialize: ->
		@listenTo(@model, 'change', @render)
	render: ->
		@$el.html @template(@model.toJSON())
		this
	enter: (e) ->
		$action = $(e.currentTarget).parent()
		Veggie.hide_nav ->
			width = $(window).width() - 48
			$(".banner",@$el).animate
				"width": width + "px"
				800
				-> 
					$(@).css "width": "auto"
					$action.css 
						"-webkit-transform": "translateX(0)"
		@$el.parent().siblings().hide()
		@$el.siblings().hide()
		@play()
	play: ->		
		unless @audio
			@audio = soundManager.createSound
				id: @model.get("_id")
				url: @model.get("url")
				autoLoad: true
		@audio.play()
		# lyrics = new Lrc @model.get("lyrics"),@show_lyrics
		# info = lyrics.tags
		# lyrics.play(0)
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
		@$el.append JST['item/lrc'](text: text)
		$alert = $(".lyrics:last-child",@$el)
		@fade_in($alert)
		@fade_out($alert.siblings())
