class window.Veggie.Courses extends Backbone.Collection
	model: Course
	url: "/courses/index"
	parse: (resp)->
		if resp.status is 0
			resp.data