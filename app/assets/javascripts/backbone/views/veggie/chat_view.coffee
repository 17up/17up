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
			_id: window.current_member.get("_id")
			content: content

		@dispatcher.trigger('new_message', message)
	enter_channel: (channel_id) ->		
		@channel = @dispatcher.subscribe(channel_id)
		data = 
			cid: channel_id
			uid: window.current_member.get("_id")
		@dispatcher.trigger('enter_channel',data)
		@$el.css("opacity":1)
		@channel.bind 'enter', (data) =>
			is_newer = @collection.length is 0
			if is_newer
				for m in data.guys
					@collection.push(new Member(m))			
				@collection.push(new Member(data.newer))
				for i in [1..(5 - @collection.length)]
					@collection.push(new Member())
			else
				m = @collection.where(_id: '')[0]
				m.set data.newer
		@channel.bind 'success', (ms) =>
			m = @collection.where(_id: ms._id)[0]
			m.trigger "say"
			if ms._id is window.current_member.get("_id")
				Utils.flash(ms.content,"success",$("#chatroom"))
			else
				Utils.flash(ms.content,"info",$("#chatroom"))
			
		@channel.bind 'leave', (data) =>
			m = @collection.where(_id: data._id)[0]
			m.set m.defaults
	leave_channel: ->
		@$el.css("opacity":0)
		data = 
			cid: @channel.name
			uid: window.current_member.get("_id")
		@dispatcher.trigger('leave_channel',data)
		@channel._callbacks = []
		@collection.reset()
		$("#chatroom #oline_users").empty()

			