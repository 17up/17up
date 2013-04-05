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
			$audio[0].load()
			$audio[0].play()
	focus_speech: (e) ->
		$(e.currentTarget).blur()
	speech: (e) ->
		self = this
		$ele = $(e.currentTarget)
		key = $ele.data().key
		w = $ele.val()
		if w.toLowerCase() is key
			Utils.flash("发音很准哦！","success")
		else
			Utils.flash("#{w}? 还差一点，加油！","error")
		$ele.blur().val('')
		setTimeout(->
			self.play_audio $("audio",self.$el)
		,500)
	enterStep: (e) ->
		self = this
		max = $(".step").length - 1
		percent = @model.get('num')*100/max
		$("#progress .current_bar").css "width": "#{percent}%"
		$ele = $(e.currentTarget)
		@model.fetch ->						
			setTimeout(->
				if $("audio",$ele).length is 1
					self.play_audio $("audio",$ele)
			,500)




		