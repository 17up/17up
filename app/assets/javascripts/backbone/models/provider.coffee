class window.Provider extends Backbone.Model
	defaults:
		"_id": ''
		"provider": ''
	fetch: (callback) ->
		self = this
		provider = self.get("provider")
		if self.get("_id") is ''
			$.get "/members/provider?provider=" + provider, (data) ->
				if data.status is 0
					self.set data.data
					callback() if callback
