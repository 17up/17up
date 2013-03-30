class window.Course extends Backbone.Model
	defaults:
		"_id": ''
		"title": ''
		"content": ''
		"tags": ''
		"status": ''
		"open": false
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
	checkin: (callback)->
		self = this
		$.post "/courses/checkin",_id:self.get("_id"),(data) ->
			if data.status is 0	
				self.set 
					has_checkin: true
				$("nav .gem").text(data.data)
				callback()
			else if data.status is -2
				Utils.flash("你的绿叶不足，还不能学这节课程","error")


	