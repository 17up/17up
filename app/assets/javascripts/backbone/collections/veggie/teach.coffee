class window.Veggie.Teach extends Backbone.Collection
	url: "/members/teach"
	parse: (resp)->
		if resp.status is 0
			resp.data