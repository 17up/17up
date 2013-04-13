class window.Word extends Backbone.Model
	defaults:
		"title": ''
		"content": ''
		"img_url": '/assets/icon/default.png'
		"imagine": false
		"synsets": []
	fetch: (callback) ->
		self = this
		$.post "/words/fetch",title: self.get("title"), (data) ->
			if data.status is 0
				self.set data.data
				callback() if callback

		