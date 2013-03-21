class window.Veggie.Genius extends Backbone.Collection
	url: "/members/genius"
	parse: (resp)->
		if resp.status is 0
			resp.data