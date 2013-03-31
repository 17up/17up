class window.Veggie.WordView extends Backbone.View
	tagName: 'div'
	className: 'step word'
	id: ->
		@model.get('title')
	attributes: ->
		"data-x": 0
		"data-y": -@model.get('num')*1000 
		"data-z": -@model.get('num')*1500	
		"data-scale": "1"
	template: JST['item/word']
	events: ->
		"enterStep": "enterStep"
		"webkitspeechchange .speech input": "speech"
		"focus .speech input": "focus_speech"
		"click .goFirst": "goFirst"
	initialize: ->
		@listenTo(@model, 'change', @render)
		@listenTo(@model, 'destroy', @remove)
	render: ->
		@$el.html @template(@model.toJSON())	
		this
	goFirst: ->
		$("#imagine").jmpress "goTo",$("#ihome")
	play_audio: ($audio) ->
		if $audio.length is 1
			unless $audio[0].src isnt ''
				$audio[0].src = $audio.attr('data')
			$audio[0].play()
	focus_speech: (e) ->
		$(e.currentTarget).blur()
	speech: (e) ->
		key = $(e.currentTarget).attr "key"
		w = $(e.currentTarget).val()
		if w.toLowerCase() is key
			Utils.flash("发音很准哦！","success")
		else
			Utils.flash("#{w}? 还差一点，加油！","error")
		$(e.currentTarget).blur()
		$(e.currentTarget).val('')
	enterStep: (e) ->
		max = $(".step").length - 1
		percent = @model.get('num')*100/max
		$("#progress .current_bar").css "width": "#{percent}%"
		@model.fetch ->				
			$ele = $(e.currentTarget)		
			# if document.createElement('input').webkitSpeech is undefined
			# 	$(".speech input",$ele).remove()
			setTimeout(->
				$audio = $ele.find("audio")
				if $audio.length is 1
					unless $audio[0].src isnt ''
						$audio[0].src = $audio.attr('data')
					$audio[0].play()
			,500)

		
		

		