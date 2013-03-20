class window.Course extends Backbone.Model
	defaults:
		"_id": ''
		"title": ''
		"content": ''
		"tags": ''
	parse: (resp)->
		if resp.status is 0
			resp.data

	