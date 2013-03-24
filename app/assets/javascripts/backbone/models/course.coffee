class window.Course extends Backbone.Model
	defaults:
		"_id": ''
		"title": ''
		"content": ''
		"tags": ''
		"status": ''
	url: "/courses/update"
	ready: ->
		self = this
		$.post "/courses/ready",_id:self.get("_id"),(data)->
			if data.status is 0	
				self.set 
					status: 2
	destroy: ->
		super()
		self = this
		$.post '/courses/destroy',_id:self.get("_id")


	