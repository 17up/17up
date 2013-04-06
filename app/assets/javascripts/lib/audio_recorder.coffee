class window.AudioRecorder
	duration: 3000
	constructor: ->
		self = this
		window.AudioContext = window.AudioContext || window.webkitAudioContext
		navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia
		window.URL = window.URL || window.webkitURL			
		self.audio_context = new AudioContext
	startRecording: (button,_id) ->
		self = this
		start_record = ->
			self.recorder.record()
			button.addClass 'ing'
			setTimeout(
				-> self.stopRecording(button,_id)
				self.duration
			)
		startUserMedia = (stream) ->
			input = self.audio_context.createMediaStreamSource(stream)
			input.connect(self.audio_context.destination)
			self.recorder = new Recorder(input)	
			start_record()	
		if self.recorder isnt undefined
			start_record()	
		else			
			navigator.getUserMedia
				audio: true
				startUserMedia
				(e) ->
					Utils.flash("请允许使用您的麦克风哦！","error")
					false
			
	stopRecording: (button,_id) ->
		self = this
		self.recorder && self.recorder.stop()
		button.removeClass 'ing'
		this.createDownloadLink(button.parent().find("audio.my"),_id)
		self.recorder.clear()
	createDownloadLink: (audio,_id) ->
		self = this
		self.recorder and self.recorder.exportWAV (blob) ->
			url = URL.createObjectURL(blob)	 
			audio[0].src = url
			audio[0].play()
			audio.parent().find(".play").removeClass("disabled")
			form = new FormData()
			form.append("file", blob)
			form.append("_id",_id)
			form.append("authenticity_token",$("footer #uploader .audio form").find("input[name='authenticity_token']").val())
			oReq = new XMLHttpRequest()
			oReq.open("POST", '/words/upload_audio_u')
			oReq.send(form)
