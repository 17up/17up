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
		"click .upload_img": "upload_img"
		"click .audio .record": "audio_record"
		"click .audio .play": "audio_play"
		"click .to_base": "to_base"
		"click .to_imagine": "to_imagine"
	initialize: ->
		@listenTo(@model, 'change', @render)
		@listenTo(@model, 'destroy', @remove)
		
	render: ->
		@$el.html @template(@model.toJSON())	
		this
	to_base: ->
		@model.set 
			imagine: false
		@play_audio $("audio.common",@$el)
	to_imagine: ->
		@model.set 
			imagine: true
		@play_audio $("audio.common",@$el)
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
				self.play_audio $("audio.common",$ele)
			,500)
			$("footer #uploader .uword input[name='_id']").val(self.model.get("_id"))
			if self.model.get('num') is 0
				Veggie.GuideView.addOne Guide.imagine("ihome")
			else if self.model.get("exam") is true
				Veggie.GuideView.addOne Guide.imagine("word")
			else if self.model.get("num") is max - 1
				Veggie.GuideView.addOne Guide.imagine("iend")
	upload_img: (e) ->
		Utils.uploader $(e.currentTarget)
	audio_record: (e) ->
		_id = @model.get("_id")
		if navigator.webkitGetUserMedia or navigator.getUserMedia
			window.recorder = window.recorder || new AudioRecorder()
			window.recorder.startRecording($(e.currentTarget),_id)
		else
			Utils.flash "您的浏览器不支持语音输入，请尝试chrome","error"
	audio_play: (e) ->
		@play_audio $(e.currentTarget).parent().find("audio")
 
		