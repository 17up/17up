class window.Veggie.Genius extends Backbone.Model
	url: "/members/genius"
	parse: (resp)->
		if resp.status is 0
			resp.data