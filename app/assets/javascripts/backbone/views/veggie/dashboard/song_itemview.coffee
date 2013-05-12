class window.Veggie.SongView extends Backbone.View
	id: "song"
	className: "left"
	template: JST['item/song']
	open: false
	events:
		"click .back": "back"
		"click .play": "play"
		"click .pause": "pause"
	back: (e) ->
		$action = $(e.currentTarget).parent()
		@open = false
		@audio.stop()
		$("span",$action).show()
		@$el.siblings().show()
		@$el.parent().siblings().show()
		$(".banner",@$el).css "width":"50%"
		$action.css 
			"-webkit-transform": "translateX(230px)"
	initialize: ->
		@audio = soundManager.createSound
			id: @model.get("_id")
			url: @model.get("url")
			autoLoad: true

	render: ->
		@$el.html @template(@model.toJSON())
		this
	play: (e) ->
		$play_btn = $(e.currentTarget)
		$pause_btn = $(e.currentTarget).next()
		if @open
			if @audio.paused
				@audio.resume()
				$play_btn.hide()
				$pause_btn.show()
			else
				$play_btn.hide()
				$pause_btn.show()
				@audio.play
					onfinish: ->
						$play_btn.show()
						$pause_btn.hide()
		else
			$play_btn.hide()
			$action = $(e.currentTarget).parent()
			@open = true
			Veggie.hide_nav =>
				width = $(window).width() - 48
				@$el.removeClass("left").animate
					"width": width + "px"
					800
					-> 
						$(@).css "width": "auto"
						$action.css 
							"-webkit-transform": "translateX(0)"					
			@$el.parent().siblings().hide()
			@$el.siblings().hide()
			@audio.play
				onfinish: ->
					$play_btn.show()
					$pause_btn.hide()
			lyrics = new Lrc @model.get("lyrics"),(text,ex) =>
				$(".lyrics_container",@$el).prepend JST['item/lrc'](text: text)
				$alert = $(".lyrics:first-child",@$el)
				@fade_in($alert)
				@fade_out($alert.siblings())
			lyrics.play(0)
	pause: (e) ->
		$play_btn = $(e.currentTarget).prev()
		$pause_btn = $(e.currentTarget)
		unless @audio.paused
			@audio.pause()
			$pause_btn.hide()
			$play_btn.show()
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
		
