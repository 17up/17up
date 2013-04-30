class window.Veggie.ChatView extends Backbone.View
	id: "chatroom"
	template: JST['widget/chatroom']
	content_id: "#chat_content"
	collection: new Veggie.Members()
	initialize: (self = this) ->	
		$("body").append(self.render().el)
		if location.href.match(/17up.org/)
			@dispatcher = new WebSocketRails('17up.org:3001/websocket')
		else
			@dispatcher = new WebSocketRails('localhost:3000/websocket')
		# @dispatcher.on_open = (data) ->
		# 	console.log data
		# @dispatcher.bind 'enter', (member)->		
		# 	console.log member.count
		
		$content = $(@content_id)
		$(document).bind "keyup",(event) ->  		 			
			if event.keyCode is 13
				content = $.trim($content.val())
				if content isnt "" 
					self.send_message(content)
					$content.val("").focus()
				else
					$content.focus()

	render: ->
		template = @template()
		@$el.html(template)
		this

	send_message: (content) ->
		message = 
			cid: @channel.name
			name: $("nav .name").text()
			content: content

		@dispatcher.trigger('new_message', message)
	enter_channel: (channel_id) ->		
		@channel = @dispatcher.subscribe(channel_id)
		data = 
			cid: channel_id
		@dispatcher.trigger('enter_channel',data)
		@$el.css("opacity":1)
		@channel.bind 'enter', (data) =>
			if @channel
				memebr = new Member(data)
				@collection.push memebr
		@channel.bind 'success', (ms) =>
			if @channel
				Utils.flash(ms.name + " 说:" + ms.content,"success")
	leave_channel: ->
		@$el.css("opacity":0)
		data = 
			cid: @channel.name
		@dispatcher.trigger('leave_channel',data)
		@channel.bind 'leave', (data) =>
			member = @collection.where
				_id: data._id
			if member
				@collection.remove member
				member[0].destroy()

			@channel._callbacks = []
			@channel = null