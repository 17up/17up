class window.Word extends Backbone.Model
	defaults:
		"_id": ''
		"title": ''
		"content": ''
		"audio": ''
		"img_url": '/assets/icon/default.png'
		"imagine": []
		"exam": false
	fetch: (callback) ->
		self = this
		title = self.get("title")
		if title and self.get("_id") is ''
			$.post "/words/fetch",title: title, (data) ->
				if data.status is 0
					self.set data.data
					callback() if callback
		else
			callback() if callback
		