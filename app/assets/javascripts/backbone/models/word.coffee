class window.Word extends Backbone.Model
	defaults:
		"_id": ''
		"title": ''
		"content": ''
		"audio": ''
		"image": ''
	fetch: (callback) ->
		self = this
		title = self.get("title")
		if title and self.get("_id") is ''
			$.post "/words/fetch",title: title, (data) ->
				if data.status is 0
					self.set 
						_id: data.data._id
						content: data.data.content
					callback()

	