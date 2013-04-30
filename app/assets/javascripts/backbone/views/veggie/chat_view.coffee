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
	find_and_remove: (_id) ->
		m = @collection.where(_id: _id)[0]
		if m
			@collection.remove m
			m.destroy()
	enter_channel: (channel_id) ->		
		@channel = @dispatcher.subscribe(channel_id)
		data = 
			cid: channel_id
		@dispatcher.trigger('enter_channel',data)
		@$el.css("opacity":1)
		@channel.bind 'enter', (data) =>
			is_newer = @collection.length is 0
			if is_newer
				for m in data.guys
					@collection.push(new Member(m))			
			@collection.push(new Member(data.newer))
			if is_newer
				for i in [1..(5 - @collection.length)]
					@collection.push(new Member())
			else
				@find_and_remove('')
		@channel.bind 'success', (ms) =>
			Utils.flash(ms.name + " : " + ms.content,"success",$("#chatroom"))
		@channel.bind 'leave', (data) =>
			@find_and_remove(data._id)
			@collection.push(new Member())
	leave_channel: ->
		@$el.css("opacity":0)
		data = 
			cid: @channel.name
		@dispatcher.trigger('leave_channel',data)
		@channel._callbacks = []
		@collection.reset()
		$("#chatroom #oline_users").empty()

			