class window.Olive.Course extends Backbone.Model
	url: "/olive/courses"
	parse: (resp)->
		if resp.status is 0
			resp.data

	