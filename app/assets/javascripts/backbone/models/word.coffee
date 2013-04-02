class window.Word extends Backbone.Model
	defaults:
		"_id": ''
		"title": ''
		"content": ''
		"audio": ''
		"image": ''
		"imagine": null
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
	imagine: (callback) ->
		self = this
		title = self.get("title")
		unless self.get("imagine")
			$.post "/words/imagine",title: title, (data) ->
				if data.status is 0
					self.set 
						imagine: data.data
					callback() if callback
		