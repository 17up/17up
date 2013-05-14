class window.Veggie.SongView extends Backbone.View
	id: "song"
	className: "left"
	template: JST['item/song']
	open: false
	events:
		"click .back": "back"
		"click .play": "play"
		"click .pause": "pause"
		"click .like": "like"
	back: (e) ->
		$action = $(e.currentTarget).parent()
		@open = false
		@audio.stop()
		$("span",$action).show()
		@$el.siblings().show()
		@$el.parent().siblings().show()
		@$el.removeClass("playing").addClass("left").css "width":"50%"	
		$action.css 
			"-webkit-transform": "translateX(230px)"
		$("#icontrol").removeClass 'active'
		$(".lyrics_container",@$el).empty()
		$("body").css "overflow":"auto"
	initialize: ->
		@audio = soundManager.createSound
			id: @model.get("_id") || "17music"
			url: @model.get("url")
			autoLoad: true

	render: ->
		@$el.html @template(@model.toJSON())
		this
	play: (e) ->
		$("body").css "overflow":"hidden"
		@$el.addClass "playing"
		$play_btn = $(e.currentTarget)
		$pause_btn = $(e.currentTarget).next()
		play_song = =>
			@lyrics = new Lrc @model.get("lyrics"),(text,ex) =>
				$(".lyrics_container",@$el).append JST['item/lrc'](text: text)
				$alert = $(".lyrics:last-child",@$el)
				@fade_out($alert.siblings())
				@fade_in($alert)
			@audio.play
				onplay: =>
					@lyrics.play(0)
				onfinish: ->
					$play_btn.show()
					$pause_btn.hide()
				onpause: =>
					@lyrics.pauseToggle()
				onresume: =>
					@lyrics.pauseToggle()
				onstop: =>
					@lyrics.stop()
				whileplaying:  ->
					percent = @position*100/@duration
					$("#progress .current_bar").css "width": "#{percent}%"			
			$("#icontrol").show().addClass 'active'
		if @open
			if @audio.paused
				@audio.resume()
				$play_btn.hide()
				$pause_btn.show()
			else
				$play_btn.hide()
				$pause_btn.show()
				play_song()
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
			play_song()
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
		,1)		
	fade_out: ($txt) ->
		$txt.css 
			"-webkit-transform":"scale(1.5)"
			"opacity": "0.0"
		$txt.on "webkitTransitionEnd",->
			$(@).remove()
	like: (e) ->
		@model.set
			liked: true
		false
